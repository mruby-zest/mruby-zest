Widget {
    ColorBox {bg: color("ff00ff") }
    ColorBox {
        bg: color("00ff00")

        ColorBox { bg: color("22cc88") }
        HarmonicEdit {
            extern: "/part0/kit0/subpars/"
        }
        
        function layout(l)
        {
            selfBox = l.genBox :subsynthharm, self
            rows = children.map {|x| x.layout l}
            Draw::Layout::vfill(l, selfBox, rows, [0.3, 0.7])
        }
    }
    ColorBox {
        bg: color("00ffff")
        TabButton {label: "amplitude" }
        TabButton {label: "bandwidth" }
        TabButton {label: "frequency" }
        TabButton {label: "filter" }

        function layout(l)
        {
            selfBox = l.genBox :subtabs, self
            cols = children.map {|x| x.layout l}
            Draw::Layout::hpack(l, selfBox, cols)
        }
    }
    
    function layout(l)
    {
        selfBox = l.genBox :subsynth, self
        rows = children.map {|x| x.layout l}
        Draw::Layout::vfill(l, selfBox, rows, [0.45, 0.5, 0.05])
    }
}
