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
        whenValue: lambda { 
            puts "menu elm selected = #{file.selected}"
            menu.file_select
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
    //1
    Button {id: learn;  label: "midi"; layoutOpts: [:no_constraint]}
    //2
    Record {}
    //3
    LearnButton { }
}
