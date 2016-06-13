Widget {
    id: subsynth

    function refresh()
    {
        sub_harmonics.refresh
    }

    VisSubHarmonics {
        id:     sub_harmonics
        extern: "/part0/kit0/subpars/response"
    }
    ColorBox {
        bg: Theme::GeneralBackground

        ColorBox {
            bg: Theme::GeneralBackground
            ParModuleRow {
                Selector {
                    //layoutOpts: [:no_constraint]
                    extern: "/part0/kit0/subpars/POvertoneSpread.type"
                    whenValue: lambda {subsynth.refresh}
                }
                Knob {
                    extern: "/part0/kit0/subpars/POvertoneSpread.par1"
                    whenValue: lambda {subsynth.refresh}
                }
                Knob {
                    extern: "/part0/kit0/subpars/POvertoneSpread.par2"
                    whenValue: lambda {subsynth.refresh}
                }
                Knob {
                    extern: "/part0/kit0/subpars/POvertoneSpread.par3"
                    whenValue: lambda {subsynth.refresh}
                }
            }
        }
        HarmonicEdit {
            extern: "/part0/kit0/subpars/"
            type:   :subsynth
            whenValue: lambda { subsynth.refresh }
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
