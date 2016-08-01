Widget {
    id: file
    layer: 2
    property Object valueRef: nil

    SelColumn {
        id: folders;
        layer: 2;
        extern: "/file_list_dirs"
        whenValue: lambda {file.set_dir(folders.selected)}
    }
    SelColumn {
        id: files;
        layer: 2;
        extern: "/file_list_files"
        whenValue: lambda {file.set_file(files.selected)}
    }
    TextLine {
        id: line
        layer: 2;
        upcase: false
    }
    TriggerButton {
        layer: 2;
        label: "Enter"
        whenValue: lambda {file.whenEnter}
    }
    TriggerButton {
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
        puts "Set home..."
        line.label = x
        line.damage_self
        $remote.action("/file_list_dirs",  x)
        $remote.action("/file_list_files", x)
    }

    function set_dir(x)
    {
        puts "set dir..."
        puts x
        line.label += "/" if line.label[-1] != "/"
        line.label += x + "/"
        line.label = path_simp(line.label)
        line.damage_self
        $remote.action("/file_list_dirs",  line.label)
        $remote.action("/file_list_files", line.label)
    }

    function set_file(x)
    {
        puts "set file..."
        puts x
        line.label += "/"
        line.label += x
        line.damage_self
    }

    function draw(vg) {
        background color("000000", 125)
    }

    function whenEnter() {
        root.ego_death self
    }

    function whenCancel() {
        root.ego_death self
    }
}
