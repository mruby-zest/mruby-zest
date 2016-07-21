Widget {
    id: file
    layer: 2
    property Object valueRef: nil

    SelColumn {
        id: folders;
        layer: 2;
        extern: "/file_list_dirs"
    }
    SelColumn {
        id: files;
        layer: 2;
        extern: "/file_list_files"
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
        l.fixed(ch[2], selfBox, 0.10,     0.70, 0.80, 0.1)
        l.fixed(ch[3], selfBox, 0.10,     0.85, 0.20, 0.1)
        l.fixed(ch[4], selfBox, 0.40,     0.85, 0.20, 0.1)
        selfBox
    }

    function onSetup(v=nil) {

        #Get files when home dir (or any subsequent dir) is setup
        dirs  = OSC::RemoteParam.new($remote, "/file_list_dirs")
        dirs.callback   = lambda { |x| set_dirs(x) }
        files = OSC::RemoteParam.new($remote, "/file_list_files")
        files.callback = lambda { |x| set_files(x) }

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

    function set_dirs(x)
    {
    }

    function set_files(x)
    {
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
