#File Browser Model
#
# Operations:
#  - setting the home directory
#  - single character addition
#  - single character deletion
#  - apply cursor motion [later version]
#  - setting the current file
#  - setting the current relative directory
#  - setting the current absolute directory
#  - setting the file mask
#  - clear flags
#
# Properties:
#  - File/Directory list needs to be refreshed
#  - Path display needs refresh or not
#  - What the current path display should show

class PathElm
    #Types:
    # - window_start
    # - unix_start
    # - full_dir
    # - partial
    attr_accessor :type
    def initialize(type, string, sep)
        @type = type
        @str  = string
        @sep  = sep
    end

    def to_s
        return "/"       if @type == :unix_start
        return @str+@sep if @type == :full_dir
        return @str
    end

end

class Path
    attr_accessor :path_elements
    def initialize(path_str)
        @unix      = !self.windows_path?(path_str)
        @separator = "/"  if  @unix
        @separator = "\\" if !@unix
        parse_unix_path(path_str)    if  @unix
        parse_windows_path(path_str) if !@unix
    end

    def parse_windows_path(path_str)
        #[A-Za-z]:\\?path\folder\etc\partial
        @path_elements = []
        partial = ""
        len = 0
        path_str.each_char do |chr|
            len = @path_elements.length
            if(chr == "\\" && len == 0 && partial.length >= 3)
                partial += chr
                @path_elements << PathElm.new(:windows_start, partial, @separator)
                partial = ""
            elsif(chr != "\\" && len == 0 && partial.length == 3)
                @path_elements << PathElm.new(:windows_start, partial, @separator)
                partial = chr
            elsif(chr != "\\" && len > 0)
                partial += chr
            elsif(chr == "\\" && len > 0)
                @path_elements << PathElm.new(:full_dir, partial, @separator)
                partial = ""
            else
                partial += chr
            end
        end
        if(len == 0 && partial.length == 3)
            @path_elements << PathElm.new(:windows_start, partial, @separator)
        end
        @path_elements << PathElm.new(:partial, partial, @separator) if len != 0 && partial != ""
    end

    def parse_unix_path(path_str)
        raise "no-windows-support" if !@unix
        @path_elements = []
        partial = ""
        len = 0
        path_str.each_char do |chr|
            len = @path_elements.length
            if(chr == "/" && len == 0)
                @path_elements << PathElm.new(:unix_start, "/", "/")
                partial = ""
            elsif(chr != "/" && len > 0)
                partial += chr
            elsif(chr == "/" && len > 0)
                @path_elements << PathElm.new(:full_dir, partial, "/")
                partial = ""
            end
        end
        @path_elements << PathElm.new(:partial, partial, "/") if len != 0 && partial != ""
    end

    def windows_path?(path)
        x = path
        return false if x.length < 2
        return false if x[0].ord < "A".ord || x[0].ord > "Z".ord
        return false if x[1].ord != 58
        return false if x[2].ord != 92
        return true
    end

    def add_dir(dir)
        len = @path_elements.length
        if(len > 1 && @path_elements[-1].type == :partial)
            @path_elements = @path_elements[0..-2]
        end
        @path_elements << PathElm.new(:full_dir, dir, @separator)
    end

    def updir
        len = @path_elements.length
        if(len == 2)
            @path_elements = [@path_elements[0]]
        elsif(len > 2 && @path_elements[-1].type == :partial)
            @path_elements = @path_elements[0..-3]
        elsif(len > 2)
            @path_elements = @path_elements[0..-2]
        end
        nil
    end

    def set_partial(part)
        len = @path_elements.length
        return if len < 1
        del_partial
        @path_elements << PathElm.new(:partial, part, @separator)
    end

    def del_partial
        len = @path_elements.length
        if(len > 1 && @path_elements[-1].type == :partial)
            @path_elements = @path_elements[0..-2]
        end
    end

    def convert_partial_to_dir
        len = @path_elements.length
        if(len > 1 && @path_elements[-1].type == :partial)
            @path_elements[-1].type = :full_dir
        end
    end


    def to_s
        @path_elements.map{|x|x.to_s}.join
    end
end


class FileBrowser
    attr_reader :needs_refresh, :path, :state

    def initialize()
        @state         = :invalid
        @current_dir   = nil
        @current_file  = nil
        @needs_refresh = true

        @path      = "/"
    end

    def set_home_dir(dir_name)
        @state = :on_dir
        path   = Path.new(dir_name)
        path.convert_partial_to_dir
        @path  = path.to_s
        $current_dir = @path
        @needs_refresh = true
    end

    def add_char(chr)
        @path += chr
        @needs_refresh = true
    end

    def del_char()
        @path = @path[0...-1] if !@path.empty?
        @needs_refresh = true
    end

    def change_file(file_name)
        raise "no home directory found..." if @state == :invalid
        path = Path.new(@path)
        path.del_partial            if file_name == ""
        path.set_partial(file_name) if file_name != ""
        npath = path.to_s
        @needs_refresh = true if npath != @path
        @path = npath
    end

    def change_dir_rel(dir_name)
        raise "no home directory found..." if @state == :invalid
        path = Path.new(@path)
        path.updir             if dir_name == ".."
        path.add_dir(dir_name) if dir_name != ".."
        npath = path.to_s
        @needs_refresh = true if npath != @path
        @path = npath
        $current_dir = @path
    end

    def change_dir_abs(dir_name)
        path = Path.new(dir_name)
        npath = path.to_s
        @needs_refresh = true if npath != @path
        @path = npath
        $current_dir = @path
    end

    def clear_flags()
        @needs_refresh = false
    end

    def search_path
        path = Path.new(@path)
        path.del_partial
        path.to_s
    end

    def set_dirs(dirs)
        @dirs = dirs
    end

    def set_files(files)
        @files = files
    end

end

if(true)
    require "test/unit"

    class FileBrowserTest < Test::Unit::TestCase
        def setup
            @file = FileBrowser.new
        end

        def teardown
            @file = nil
        end

        def test_no_home
            assert_raise(RuntimeError) {
                @file.change_dir_rel("..")
            }

            assert_raise(RuntimeError) {
                @file.change_file("anything")
            }

            @file.set_home_dir "/foo/bar/blam/"

            assert_nothing_raised {
                @file.change_dir_rel("..")
            }

            assert_nothing_raised {
                @file.change_file("anything")
            }
        end

        def test_paths
            tmp = Path.new("/foo/bar/")
            assert_equal("/foo/bar/", tmp.to_s)
            tmp = Path.new("/foo/bar")
            assert_equal("/foo/bar", tmp.to_s)
        end

        def test_unix_cd
            @file.set_home_dir "/foo/bar/blam/"
            assert_equal("/foo/bar/blam/", @file.path)
            assert_equal(true, @file.needs_refresh)

            @file.clear_flags
            assert_equal(false, @file.needs_refresh)

            @file.change_dir_rel "box"
            assert_equal("/foo/bar/blam/box/", @file.path)
            assert_equal(true, @file.needs_refresh)

            @file.change_dir_rel ".."
            assert_equal("/foo/bar/blam/", @file.path)

            @file.change_dir_rel ".."
            assert_equal("/foo/bar/", @file.path)

            @file.change_dir_rel ".."
            assert_equal("/foo/", @file.path)

            @file.change_dir_rel ".."
            assert_equal("/", @file.path)

            assert_equal(true, @file.needs_refresh)
            @file.clear_flags
            assert_equal(false, @file.needs_refresh)

            @file.change_dir_rel ".."
            assert_equal("/", @file.path)

            @file.change_dir_rel ".."
            assert_equal("/", @file.path)
        end

        def test_unix_file
            @file.set_home_dir "/foo/bar/blam/"
            assert_equal("/foo/bar/blam/", @file.path)
            assert_equal(true, @file.needs_refresh)

            assert_equal(true, @file.needs_refresh)
            @file.clear_flags
            assert_equal(false, @file.needs_refresh)

            @file.change_file "testa"
            assert_equal("/foo/bar/blam/testa", @file.path)
            assert_equal("/foo/bar/blam/", @file.search_path)

            assert_equal(true, @file.needs_refresh)
            @file.clear_flags
            assert_equal(false, @file.needs_refresh)

            @file.change_file "xxx"
            assert_equal("/foo/bar/blam/xxx", @file.path)
            assert_equal("/foo/bar/blam/", @file.search_path)

            assert_equal(true, @file.needs_refresh)
            @file.clear_flags
            assert_equal(false, @file.needs_refresh)

            @file.change_file ""
            assert_equal("/foo/bar/blam/", @file.path)
            assert_equal("/foo/bar/blam/", @file.search_path)

            assert_equal(true, @file.needs_refresh)
            @file.clear_flags
            assert_equal(false, @file.needs_refresh)
        end

        def test_unix_set_home
            @file.set_home_dir "/foo/bar/blam/"
            assert_equal("/foo/bar/blam/", @file.path)
            @file.set_home_dir "/foo/bar/blam"
            assert_equal("/foo/bar/blam/", @file.path)
        end

        def test_unix_add_char
            @file.set_home_dir "/foo/bar/blam"
            assert_equal("/foo/bar/blam/", @file.path)
            @file.add_char "a"
            assert_equal("/foo/bar/blam/a", @file.path)
            @file.add_char "b"
            @file.clear_flags
            assert_equal(false, @file.needs_refresh)
            @file.add_char "c"
            assert_equal(true, @file.needs_refresh)
            @file.add_char "d"
            assert_equal("/foo/bar/blam/abcd", @file.path)
            @file.del_char
            assert_equal("/foo/bar/blam/abc", @file.path)
            4.times { @file.del_char }
            assert_equal("/foo/bar/blam", @file.path)
            assert_equal("/foo/bar/",     @file.search_path)
            40.times { @file.del_char }
            assert_equal("", @file.path)
            assert_equal("", @file.search_path)
        end

        def test_windows_set_home
            @file.set_home_dir "C:\\\\windows\\paths\\are\\dumb"
            assert_equal("C:\\\\windows\\paths\\are\\dumb\\", @file.path)
            @file.set_home_dir "C:\\\\windows\\paths\\are\\dumb\\"
            assert_equal("C:\\\\windows\\paths\\are\\dumb\\", @file.path)
        end

        def test_window_cd
            @file.set_home_dir "C:\\\\foo\\bar\\blam"
            assert_equal("C:\\\\foo\\bar\\blam\\", @file.path)
            assert_equal(true, @file.needs_refresh)

            @file.clear_flags
            assert_equal(false, @file.needs_refresh)

            @file.change_dir_rel "box"
            assert_equal("C:\\\\foo\\bar\\blam\\box\\", @file.path)
            assert_equal(true, @file.needs_refresh)

            @file.change_dir_rel ".."
            assert_equal("C:\\\\foo\\bar\\blam\\", @file.path)

            @file.change_dir_rel ".."
            assert_equal("C:\\\\foo\\bar\\", @file.path)

            @file.change_dir_rel ".."
            assert_equal("C:\\\\foo\\", @file.path)

            @file.change_dir_rel ".."
            assert_equal("C:\\\\", @file.path)

            assert_equal(true, @file.needs_refresh)
            @file.clear_flags
            assert_equal(false, @file.needs_refresh)

            @file.change_dir_rel ".."
            assert_equal("C:\\\\", @file.path)

            @file.change_dir_rel ".."
            assert_equal("C:\\\\", @file.path)
        end

        def test_window_cd_alt
            @file.set_home_dir "C:\\foo\\bar\\blam"
            assert_equal("C:\\foo\\bar\\blam\\", @file.path)
            assert_equal(true, @file.needs_refresh)

            @file.clear_flags
            assert_equal(false, @file.needs_refresh)

            @file.change_dir_rel "box"
            assert_equal("C:\\foo\\bar\\blam\\box\\", @file.path)
            assert_equal(true, @file.needs_refresh)

            @file.change_dir_rel ".."
            assert_equal("C:\\foo\\bar\\blam\\", @file.path)

            @file.change_dir_rel ".."
            assert_equal("C:\\foo\\bar\\", @file.path)

            @file.change_dir_rel ".."
            assert_equal("C:\\foo\\", @file.path)

            @file.change_dir_rel ".."
            assert_equal("C:\\", @file.path)

            assert_equal(true, @file.needs_refresh)
            @file.clear_flags
            assert_equal(false, @file.needs_refresh)

            @file.change_dir_rel ".."
            assert_equal("C:\\", @file.path)

            @file.change_dir_rel ".."
            assert_equal("C:\\", @file.path)
        end

        def test_windows_file
            @file.set_home_dir "C:\\\\foo\\bar\\blam\\"
            assert_equal(      "C:\\\\foo\\bar\\blam\\", @file.path)
            assert_equal(true, @file.needs_refresh)

            assert_equal(true, @file.needs_refresh)
            @file.clear_flags
            assert_equal(false, @file.needs_refresh)

            @file.change_file "testa"
            assert_equal("C:\\\\foo\\bar\\blam\\testa", @file.path)
            assert_equal("C:\\\\foo\\bar\\blam\\", @file.search_path)

            assert_equal(true, @file.needs_refresh)
            @file.clear_flags
            assert_equal(false, @file.needs_refresh)

            @file.change_file "xxx"
            assert_equal("C:\\\\foo\\bar\\blam\\xxx", @file.path)
            assert_equal("C:\\\\foo\\bar\\blam\\", @file.search_path)

            assert_equal(true, @file.needs_refresh)
            @file.clear_flags
            assert_equal(false, @file.needs_refresh)

            @file.change_file ""
            assert_equal("C:\\\\foo\\bar\\blam\\", @file.path)
            assert_equal("C:\\\\foo\\bar\\blam\\", @file.search_path)

            assert_equal(true, @file.needs_refresh)
            @file.clear_flags
            assert_equal(false, @file.needs_refresh)
        end

        def test_windows_change_drive
            @file.set_home_dir "C:\\\\foo"
            assert_equal("C:\\\\foo\\", @file.path)
            10.times {@file.del_char}
            assert_equal("", @file.path)
            @file.add_char "Z"
            @file.add_char ":"
            @file.add_char "\\"
            @file.add_char "\\"
            assert_equal("Z:\\\\", @file.path)
            @file.change_file("blam")
            assert_equal("Z:\\\\blam", @file.path)
        end

    end
end
