Widget {
    Widget {
        Group {
            label: "tunings"
            ColorBox { pad: 0.03; bg: color("222222") }
        }
        Group {
            label: "keyboard mapping"
            ColorBox { pad: 0.03; bg: color("222222") }
        }
        function layout(l)
        {
            selfBox = l.genBox :part, self
            rows = children.map {|x| x.layout l}
            Draw::Layout::hfill(l, selfBox, rows, [0.5, 0.5])
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

    function layout(l)
    {
        selfBox = l.genBox :part, self
        rows = children.map {|x| x.layout l}
        Draw::Layout::vfill(l, selfBox, rows, [0.9, 0.1])
    }
}
