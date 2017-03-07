Widget {
    id: scale
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
            FileButton {
                label: "import .scl"
                extern: "/load_scl"
            }
            FileButton {
                label: "import .kbm"
                extern: "/load_kbm"
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
