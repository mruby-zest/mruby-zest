Widget {
    Widget {
        Group {
            label: "tunings"
            ColorBox { pad: 0.03; bg: color("222222") }
        }
        Group {
            label: "key mapping"
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
            Button { label: "import .scl" }
            Button { label: "import .kbm" }
            Button { label: "import .retune" }
        }
    }

    function class_name() { "part" }
    function layout(l) {
        Draw::Layout::vfill(l, self_box(l), chBoxes(l), [0.9, 0.1])
    }
}
