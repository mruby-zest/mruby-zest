Widget {
    VisSubHarmonics {
        id:     sub_harmonics
        extern: "/part0/kit0/subpars/response"
    }
    Widget {
        Widget {
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

            function draw(vg) {
                Draw::GradBox(vg, Rect.new(0,0,w,h))
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
    function layout(l) {
        selfBox = l.genBox :subsynth, self
        Draw::Layout::vfill(l, selfBox, chBoxes(l), [0.45, 0.55])
    }
}
