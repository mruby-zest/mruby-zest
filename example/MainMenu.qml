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
        options: ["clear", "load", "save", "quit"]
        whenValue: lambda { menu.file_select }
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
        wid.x = -global_x
        wid.y = -global_y
        wid.w = win.w
        wid.h = win.h
        Qml::add_child(win, wid)
        self.db.update_values
        setup_widget wid
        self.db.update_values
        puts self

        if(root)
            puts "smash layout"
            root.smash_layout
            root.smash_draw_seq
            root.damage_item(win, :all)
        end
    }
    //1
    Button {id: learn;  label: "midi"; layoutOpts: [:no_constraint]}
    //2
    Record {}
    //3
    LearnButton { }
}
