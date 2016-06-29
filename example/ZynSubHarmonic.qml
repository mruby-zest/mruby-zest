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
                    whenValue: lambda {sub_harmonics.refresh}
                }
                Knob {
                    extern: "/part0/kit0/subpars/POvertoneSpread.par1"
                    whenValue: lambda {sub_harmonics.refresh}
                }
                Knob {
                    extern: "/part0/kit0/subpars/POvertoneSpread.par2"
                    whenValue: lambda {sub_harmonics.refresh}
                }
                Knob {
                    extern: "/part0/kit0/subpars/POvertoneSpread.par3"
                    whenValue: lambda {sub_harmonics.refresh}
                }
            }

            function draw(vg) {
                Draw::GradBox(vg, Rect.new(0,0,w,h))
            }
        }
        HarmonicEdit {
            extern: "/part0/kit0/subpars/"
            type:   :subsynth
            whenValue: lambda { sub_harmonics.refresh }
        }

        function class_name() { "subsynthharm" }
        function layout(l) {
            Draw::Layout::vfill(l, self_box(l), chBoxes(l), [0.3, 0.7])
        }
    }
    function class_name() { "subsynth" }
    function layout(l) {
        Draw::Layout::vfill(l, self_box(l), chBoxes(l), [0.45, 0.55])
    }
}
