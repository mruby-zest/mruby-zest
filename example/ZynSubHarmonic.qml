Widget {
    id: harm

    VisSubHarmonics {
        id:     sub_harmonics
        extern: harm.extern + "response"
    }
    Widget {
        ParModuleRow {
            lsize: 0.3
            TriggerButton   {
                label: "clear"
                whenValue: lambda {harm.clear}
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
        id: edit
        extern: harm.extern
        type:   :subsynth
        whenValue: lambda { sub_harmonics.refresh }
    }
    function class_name() { "subsynth" }
    function layout(l, selfBox) {
        Draw::Layout::vfill(l, selfBox, children, [0.50, 0.10, 0.40])
    }
    function clear() {
        edit.clear
        sub_harmonics.refresh
    }
}
