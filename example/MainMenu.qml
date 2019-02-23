Widget {
    id: menu
    function layout(l, selfBox) {
        pad  = 1/32
        pad2 = 0.5-2*pad
        children[0].fixed(l, selfBox, 0.0+pad, 0.0+pad, pad2, pad2)
        children[1].fixed(l, selfBox, 0.5+pad, 0.0+pad, pad2, pad2)
        children[2].fixed(l, selfBox, 0.0+pad, 0.5+pad, pad2, pad2)
        children[3].fixed(l, selfBox, 0.5+pad, 0.5+pad, pad2, pad2)

        selfBox
    }

    //0
    Menu {
        id: file;
        label: "file";
        layoutOpts: [:no_constraint]
        options: ["load instrument", "save instrument",
                  "load master", "save master",
                  "load microtonal", "save microtonal",
                  "load midi bindings", "save midi bindings",
                  "clear master", "clear instrument",
                  "setup record", "quit"]
        whenValue: lambda {
            menu.file_sel if file.selected
        }
    }

    function setup_widget(w)
    {
        w.onSetup()
        w.children.each do |c|
            setup_widget(c)
        end
    }

    function file_select()
    {
        opt = file.options[file.selected]
        win = window()
        wid = Qml::FileSelector.new(db)
        wid.whenValue = lambda { |x| menu.file_value(x)}
        wid.x = 0#-global_x
        wid.y = 0#-global_y
        wid.w = win.w
        wid.h = win.h
        wid.ext = ".xiz" if opt == "save instrument"
        wid.ext = ".xmz" if opt == "save master"
        wid.ext = ".wav" if opt == "setup record"
        wid.pat = ".xiz" if opt == "load instrument"
        wid.pat = ".xmz" if opt == "load master"
        wid.pat = ".xsz" if opt == "load microtonal"
        wid.pat = ".xsz" if opt == "save microtonal"
        wid.pat = ".xlz" if opt == "load midi bindings"
        wid.pat = ".xlz" if opt == "save midi bindings"
        Qml::add_child(win, wid)
        self.db.update_values
        setup_widget wid
        self.db.update_values

        if(root)
            root.smash_layout
            root.damage_item(win, :all)
        end
    }

    function file_sel()
    {
        opt = file.options[file.selected]
        if(["load instrument", "save instrument", "load master", "save master", "setup record",
            "load microtonal", "save microtonal", "load midi bindings", "save midi bindings"].include? opt)
            menu.file_select
        elsif(opt == "clear master")
            root.set_view_pos(:part, 0)
            root.set_view_pos(:kit, 0)
            root.set_view_pos(:voice, 0)
            root.set_view_pos(:view, :add_synth)
            root.set_view_pos(:subview, :global)
            root.change_view
            $remote.action("/reset_master")
        elsif(opt == "clear instrument")
            root.set_view_pos(:voice, 0)
            root.set_view_pos(:kit, 0)
            root.set_view_pos(:view, :add_synth)
            root.set_view_pos(:subview, :global)
            prt  = root.get_view_pos(:part)
            root.change_view
            $remote.action("/part#{prt}/clear")
        elsif(opt == "quit")
            $remote.action("/quit")
            root.quit
        else
            puts "[WARNING] Unhandled Option #{opt}"
        end

    }

    function file_value(val)
    {
        return if val == :cancel
        opt = file.options[file.selected]
        prt  = root.get_view_pos(:part)
        if(opt == "load instrument")
            $remote.action("/load_xiz", prt, val)
        elsif(opt == "save instrument")
            $remote.action("/save_xiz", prt, val)
        elsif(opt == "load master")
            $remote.action("/load_xmz", val)
        elsif(opt == "save master")
            $remote.action("/save_xmz", val)
        elsif(opt == "save microtonal")
            $remote.action("/save_xsz", val)
        elsif(opt == "load microtonal")
            $remote.action("/load_xsz", val)
        elsif(opt == "save midi bindings")
            $remote.action("/save_xlz", val)
        elsif(opt == "load midi bindings")
            $remote.action("/load_xlz", val)
        elsif(opt == "setup record")
            $remote.action("/HDDRecorder/preparefile", val)
        end
    }
    //1
    Button {
        id: learn;
        label: "midi";
        tooltip: "use ctrl to enable midi learn"
        layoutOpts: [:no_constraint]
    }
    //2
    Record {}
    //3
    LearnButton { 
        tooltip: "just click on a widget while in learning mode to start mapping"
    }
}
