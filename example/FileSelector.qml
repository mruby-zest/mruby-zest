Widget {
    id: file
    layer: 2
    property Object valueRef: nil
    property Function whenValue: nil

    property String state:     "invalid-dir"
    property String path_mode: "unix"
    property String ext:       nil
    property String pat:       nil

    SelColumn {
        id: folders;
        layer: 2;
        extern: "/file_list_dirs"
        clear_on_extern: true
        whenValue: lambda {file.set_dir(folders.selected)}
    }
    SelColumn {
        id: files;
        layer: 2;
        extern: "/file_list_files"
        clear_on_extern: true
        pattern: file.pat
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

    function layout(l) {
        puts "layout of file editor"
        selfBox = self_box(l)
        ch      = chBoxes(l)
        hpad = 0.10
        l.fixed(ch[0], selfBox, 0.0+hpad, 0.05, 0.5-2*hpad, 0.60)
        l.fixed(ch[1], selfBox, 0.5+hpad, 0.05, 0.5-2*hpad, 0.60)
        l.fixed(ch[2], selfBox, 0.10,     0.73, 0.80, 0.03)
        l.fixed(ch[3], selfBox, 0.10,     0.85, 0.20, 0.1)
        l.fixed(ch[4], selfBox, 0.40,     0.85, 0.20, 0.1)
        selfBox
    }

    function onSetup(v=nil) {

        #Get files when home dir (or any subsequent dir) is setup
        dirs  = OSC::RemoteParam.new($remote, "/file_list_dirs")
        #dirs.callback   = lambda { |x| set_dirs(x) }
        files = OSC::RemoteParam.new($remote, "/file_list_files")
        #files.callback = lambda { |x| set_file(x) }

        #Get the starting path i.e. the HOME dir
        home  = OSC::RemoteParam.new($remote, "/file_home_dir")
        home.callback = lambda { |x| set_home(x) }

        self.valueRef = [dirs, files, home]
    }

    function set_home(x)
    {
        line.label = x
        line.damage_self
        set_state("in-directory")
        $remote.action("/file_list_dirs",  x)
        $remote.action("/file_list_files", x)
    }

    function set_dir(x)
    {
        return if x.nil? || x.empty?

        if(self.state == "on-file")
            line.label = updir(line.label)
            set_state("in-directory")
        end

        line.label += "/" if line.label[-1] != "/"
        line.label += x + "/"
        line.label = path_simp(line.label)
        line.damage_self
        set_state("in-directory")
        $remote.action("/file_list_dirs",  line.label)
        $remote.action("/file_list_files", line.label)
    }

    function check()
    {
        line.label = "/" if line.label.empty?
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
        set_state("partial-file-dir")
        dir = line.label
        dir = updir(dir) if dir[-1] != "/"
        $remote.action("/file_list_dirs",  dir)
        $remote.action("/file_list_files", dir)
    }

    function set_file(x)
    {
        if(x.nil? || x.empty?)
            puts "up directory"
            set_state("in-directory")
            line.label = updir(line.label)
            line.damage_self
        else
            set_state("on-file")
            line.label += "/"
            line.label += x
            line.damage_self
        end
    }

    function simplify()
    {
        line.label = path_simp(line.label)
    }

    function updir(x)
    {
        dat = x.split("/").reverse
        dat[1..dat.length].reverse.join("/")
    }

    function set_state(x)
    {
        self.state = x
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
}
