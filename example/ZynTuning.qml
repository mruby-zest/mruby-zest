Widget {
    id: scale
    Widget {
        Group {
            id: tune
            label: "tunings"
            extern: scale.extern + "tunings"
            copyable: false
            ColorBox { pad: 0.03; bg: color("222222") }
        }
        Group {
            id: mapp
            label: "key mapping"
            extern: scale.extern + "mapping"
            copyable: false
            ColorBox { pad: 0.03; bg: color("222222") }
        }
        function class_name() { "partsub" }
        function layout(l) {
            Draw::Layout::hfill(l, self_box(l), chBoxes(l), [0.5, 0.5])
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
            }
        }
    }

    function class_name() { "part" }
    function layout(l) {
        Draw::Layout::vfill(l, self_box(l), chBoxes(l), [0.9, 0.1])
    }

    function apply() {
        tune.apply
        mapp.apply
    }
}
