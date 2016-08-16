Widget {
    id: menu
    function layout(l)
    {
        puts "Menu layout"
        selfBox = l.genBox :menu, menu
        chBox   = chBoxes(l)
        puts "chBox.length = #{chBox.length}"

        pad  = 1/32
        pad2 = 0.5-2*pad
        l.fixed(chBox[0], selfBox, 0.0+pad, 0.0+pad, pad2, pad2)
        l.fixed(chBox[1], selfBox, 0.5+pad, 0.0+pad, pad2, pad2)
        l.fixed(chBox[2], selfBox, 0.0+pad, 0.5+pad, pad2, pad2)
        l.fixed(chBox[3], selfBox, 0.5+pad, 0.5+pad, pad2, pad2)

        selfBox
    }

    //0
    Menu {
        id: file;
        label: "file";
        layoutOpts: [:no_constraint]
        options: ["load instrument", "save instrument",
                  "load master", "save master",
                  "clear master", "clear instrument", "quit"]
        whenValue: lambda {
            menu.file_sel
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
        puts "file select"
        win = window()
        wid = Qml::FileSelector.new(db)
        wid.whenValue = lambda { |x| menu.file_value(x)}
        wid.x = 0#-global_x
        wid.y = 0#-global_y
        wid.w = win.w
        wid.h = win.h
        #puts "[DEBUG] Add Child"
        Qml::add_child(win, wid)
        #puts "[DEBUG] Update Values"
        self.db.update_values
        #puts "[DEBUG] Setup"
        setup_widget wid
        #puts "[DEBUG] Update Values 2"
        self.db.update_values
        #puts self

        if(root)
            #puts "smash layout"
            root.smash_layout
            root.damage_item(win, :all)
        end
    }

    function file_sel()
    {
        opt = file.options[file.selected]
        if(["load instrument", "save instrument", "load master", "save master"].include? opt)
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
        else
            puts "[WARNING] Unhandled Option #{opt}"
        end

    }

    function file_value(val)
    {
        puts "I got a #{val.inspect}"
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
        end
    }
    //1
    Button {id: learn;  label: "midi"; layoutOpts: [:no_constraint]}
    //2
    Record {}
    //3
    LearnButton { }
}
