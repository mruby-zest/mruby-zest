Widget {
    id: file
    layer: 2
    property Object valueRef: nil
    property Function whenValue: nil

    property String state:     "invalid-dir"
    property String path_mode: "unix"
    property String path_sep:  "/"
    property String ext:       nil
    property String pat:       nil

    SelColumn {
        id: folders
        layer: 2
        extern: "/file_list_dirs"
        doupcase: false
        nrows: 20
        clear_on_extern: true
        whenValue: lambda {file.set_dir(folders.selected)}
    }
    SelColumn {
        id: files
        layer: 2
        extern: "/file_list_files"
        nrows: 20
        doupcase: false
        clear_on_extern: true
        pattern: Regexp.new(file.pat) if file.pat
        whenValue: lambda {file.set_file(files.selected)}
    }
    TextLine {
        id: line
        layer: 2;
        upcase: false
        ext:    file.ext
        whenValue: lambda {file.check}
    }
    TriggerButton {
        id:    ebutton
        layer: 2;
        label: "Enter"
        whenValue: lambda {file.whenEnter}
    }
    TriggerButton {
        id:    cbutton
        layer: 2;
        label: "cancel"
        whenValue: lambda {file.whenCancel}
    }

    Menu {
        id: favs
        options: []
        layer: 2
        layoutOpts: [:no_constraint]
        label: "favorites"
        whenValue: lambda {
            file.set_pos(favs.options[favs.selected]) if favs.selected
        }
    }

    TriggerButton {
        id: add
        label: "add favorite"
        layer: 2
        whenValue: lambda { file.addFav }
        layoutOpts: [:no_constraint]
    }

    function layout(l) {
        selfBox = self_box(l)
        ch      = chBoxes(l)
        hpad = 0.10
        l.fixed(ch[0], selfBox, 0.0+hpad, 0.10, 0.5-2*hpad, 0.60)
        l.fixed(ch[1], selfBox, 0.5+hpad, 0.10, 0.5-2*hpad, 0.60)
        l.fixed(ch[2], selfBox, 0.10,     0.73, 0.80, 0.03)
        l.fixed(ch[3], selfBox, 0.10,     0.85, 0.20, 0.1)
        l.fixed(ch[4], selfBox, 0.40,     0.85, 0.20, 0.1)
        l.fixed(ch[5], selfBox, 0.0+hpad, 0.02, 0.2,  0.05)
        l.fixed(ch[6], selfBox, 0.3+hpad, 0.02, 0.2,  0.05)
        selfBox
    }

    function onSetup(v=nil) {

        #Get files when home dir (or any subsequent dir) is setup
        dirs  = OSC::RemoteParam.new($remote, "/file_list_dirs")
        #dirs.callback   = lambda { |x| set_dirs(x) }
        files = OSC::RemoteParam.new($remote, "/file_list_files")
        #files.callback = lambda { |x| set_file(x) }

        #Get the starting path i.e. the HOME dir
        home = nil
        if($current_dir.nil?)
            home  = OSC::RemoteParam.new($remote, "/file_home_dir")
            home.callback = lambda { |x| set_home(x) }
        else
            set_home($current_dir)
        end

        fav   = OSC::RemoteParam.new($remote, "/config/favorites")
        fav.callback  = lambda { |x| set_favs(x) }

        self.valueRef = [dirs, files, home]
    }

    function is_windows_path(x)
    {
        return false if x.length < 4
        return false if x[0].ord < "A".ord || x[0].ord > "Z".ord
        return false if x[1].ord != 58
        return false if x[2].ord != 92
        return true
    }

    function set_home(x)
    {
        line.label = x
        line.damage_self
        set_state("in-directory")
        $remote.action("/file_list_dirs",  x)
        $remote.action("/file_list_files", x)
        self.path_mode = "windows" if is_windows_path(x)
        self.path_sep  = "\\"      if path_mode == "windows"

        if(self.valueRef && self.valueRef[2])
            self.valueRef[2].clean
            self.valueRef = [self.valueRef[0], self.valueRef[1], nil]
        end
    }

    function set_dir(x)
    {
        return if x.nil? || x.empty?

        if(self.state == "on-file")
            line.label = updir(line.label)
            set_state("in-directory")
        end

        line.label += path_sep if line.label[-1] != path_sep
        line.label += x + path_sep
        simplify()
        line.damage_self
        set_state("in-directory")
        $remote.action("/file_list_dirs",  line.label)
        $remote.action("/file_list_files", line.label)
    }

    function set_favs(x)
    {
        return if x.nil? || x.empty?

        favs.options =  x  if x.class == Array
        favs.options = [x] if x.class != Array
        favs.damage_self
    }

    function set_pos(x)
    {
        return if x.nil?
        set_state("in-directory")
        line.label = x
        line.damage_self
        check()
    }

    function addFav()
    {
        if line.label[-1] != path_sep
            add.label = "Missing Path Sep."
            return
        end
        $remote.action("/config/add-favorite", line.label)
        $remote.action("/config/favorites")
    }

    function check()
    {
        line.label = "/"    if line.label.empty? && path_mode == "unix"
        return if line.label.empty? && path_mode == "windows"
        if(line.label[-1].ord == 27) #esc
            whenCancel
            return
        elsif(line.label[-1].ord == 9) #tab
            if(ebutton.value != true)
                ebutton.value = true
                cbutton.value = 0.0
            else
                cbutton.value = true
                ebutton.value = 0.0
            end
            ebutton.damage_self
            cbutton.damage_self
            line.label = line.label[0...-1]
            return
        elsif(line.label[-1].ord == 13) #enter
            line.label = line.label[0...-1]
            if(cbutton.value == true)
                whenCancel
                return
            else
                whenEnter
                return
            end
        end
        if(line.label[-1] != path_sep)
            last = line.label.split(path_sep)[-1]
            set_state("partial-file-dir")
            folders.pattern = Regexp.new(last)
            files.pattern   = Regexp.new(last)          if file.pat.nil?
            files.pattern   = Regexp.new(last+".*"+pat) if file.pat
        else
            folders.pattern = nil
            files.pattern   = nil              if file.pat.nil?
            files.pattern   = Regexp.new(pat)  if file.pat
            set_state("in-directory")
        end
        dir = line.label
        if(dir[-1] != path_sep)
            dir = updir(dir)
        else
            #hacky work around c-string conversion bug
            dir2 = ""
            dir.each_char do |c|
                dir2 += c
            end
            dir = dir2
        end

        $remote.action("/file_list_dirs",  dir)
        $remote.action("/file_list_files", dir)
    }

    function set_file(x)
    {
        if(x.nil? || x.empty?)
            set_state("in-directory")
            line.label = updir(line.label)
            line.damage_self
        else
            line.label = updir(line.label) if self.state == "on-file"
            set_state("on-file")
            line.label += path_sep
            line.label += x
            line.damage_self
        end
    }

    function simp_win(x)
    {
        dat = x.split("\\").reverse
        todel = 0
        o = []
        dat.each do |d|
            if(d == "..")
                todel += 1
            elsif(todel != 0)
                todel -= 1
            elsif(d != "")
                o << d
            end
        end
        return "C:\\" if o.empty?
        o << ""
        tmp = o.reverse.join("\\")
        tmp[1..tmp.length]
    }

    function simplify()
    {
        line.label = path_simp(line.label) if path_mode == "unix"
        line.label = simp_win(line.label)  if path_mode == "windows"
    }

    function updir(x)
    {
        dat = x.split(path_sep).reverse
        tmp = dat[1..dat.length].reverse.join(path_sep)
        if(path_mode == "unix")
            tmp
        else
            tmp[1..tmp.length]
        end
    }

    function set_state(x)
    {
        self.state = x
        $current_dir = line.label if x == "in-directory"
    }

    function draw(vg) {
        background color("000000", 125)
    }

    function whenEnter() {
        ll = line.label
        ll = ll + self.ext if self.ext && !ll.end_with?(self.ext)
        whenValue.call(ll) if whenValue
        root.ego_death self
    }

    function whenCancel() {
        whenValue.call(:cancel) if whenValue
        root.ego_death self
    }

    function animate() {
        if(add.label == "Missing Path Sep.")
            @timer = Time.new if(@timer == nil)
            if((Time.new-@timer) > 1.5)
                add.label = "add favorite"
                @timer = nil
                add.damage_self
            end
        end
    }

    function onMousePress(m)
    {
    }
}
