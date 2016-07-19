Widget {
    id: harm

    VisSubHarmonics {
        id:     sub_harmonics
        extern: harm.extern + "response"
    }
    Widget {
        Widget {
            ParModuleRow {
                TriggerButton   {
                    label: "clear"
                }
                Selector {
                    extern: harm.extern + "Phmagtype"
                    whenValue: lambda {sub_harmonics.refresh}
                }
                NumEntry {
                    label:  "stages"
                    extern: harm.extern + "Pnumstages"
                    whenValue: lambda {sub_harmonics.refresh}
                }
                Widget { label: "          " }
                Selector {
                    //layoutOpts: [:no_constraint]
                    extern: harm.extern+"POvertoneSpread.type"
                    whenValue: lambda {sub_harmonics.refresh}
                }
                Knob {
                    extern: harm.extern+"POvertoneSpread.par1"
                    whenValue: lambda {sub_harmonics.refresh}
                }
                Knob {
                    extern: harm.extern+"POvertoneSpread.par2"
                    whenValue: lambda {sub_harmonics.refresh}
                }
                Knob {
                    extern: harm.extern+"POvertoneSpread.par3"
                    whenValue: lambda {sub_harmonics.refresh}
                }
            }

            function draw(vg) {
                Draw::GradBox(vg, Rect.new(0,0,w,h))
            }
        }
        HarmonicEdit {
            extern: harm.extern
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
