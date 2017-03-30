Widget {
    id: scale
    function load_scale(type)
    {
        @opt = type
        win = window()
        wid = Qml::FileSelector.new(db)
        wid.whenValue = lambda { |x| scale.load_scale_file(x)}
        wid.x = 0
        wid.y = 0
        wid.w = win.w
        wid.h = win.h
        wid.pat = type
        Qml::add_child(win, wid)
        self.db.update_values
        setup_widget wid
        self.db.update_values

        if(root)
            root.smash_layout
            root.damage_item(win, :all)
        end
    }
    
    function setup_widget(w)
    {
        w.onSetup()
        w.children.each do |c|
            setup_widget(c)
        end
    }

    function load_scale_file(val)
    {
        $remote.action("/load_kbm", val) if @opt == ".kbm"
        $remote.action("/load_scl", val) if @opt == ".scl"
        $remote.action("/microtonal/mapping")
        $remote.action("/microtonal/tunings")
    }

    Widget {
        Group {
            id: tune
            label: "tunings"
            extern: scale.extern + "tunings"
            copyable: false
            TextEdit {
                height: 0.05
                extern: "/microtonal/tunings"
            }
            //ColorBox { pad: 0.03; bg: color("222222") }
        }
        Group {
            id: mapp
            label: "key mapping"
            extern: scale.extern + "mapping"
            copyable: false
            TextEdit {
                height: 0.05
                extern: "/microtonal/mapping"
            }
            //ColorBox { pad: 0.03; bg: color("222222") }
        }
        function class_name() { "partsub" }
        function layout(l, selfBox) {
            Draw::Layout::hfill(l, selfBox, children, [0.5, 0.5])
        }
    }
    ColorBox {
        bg: Theme::GeneralBackground
        ParModuleRow {
            TriggerButton {
                label: "import .scl"
                tooltip: "load microtonal scale"
                whenValue: lambda {scale.load_scale(".scl")}
            }
            TriggerButton {
                label: "import .kbm"
                tooltip: "load keyboard mapping"
                whenValue: lambda {scale.load_scale(".kbm")}
            }
            TriggerButton {
                label: "retune"
                whenValue: lambda { scale.apply }
                active: false
            }
        }
    }

    function class_name() { "part" }
    function layout(l, selfBox) {
        Draw::Layout::vfill(l, selfBox, children, [0.9, 0.1])
    }

    function apply() {
        return false
        tune.apply
        mapp.apply
    }
}
