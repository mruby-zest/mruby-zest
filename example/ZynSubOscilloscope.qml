Widget{
    id: suboscill
    extern: "/part0/kit0/subpars/"

    ZynOscilloscope{
        options: ["SubNote", "subNote1"]
        opt_vals: ["/part0/kit0/subpars/noteout","/part0/kit0/subpars/noteout1"] 
    }
    Widget {
        Group {
            label: "general"
            ParModuleRow {
                ToggleButton { extern: suboscill.extern + "Pstereo" }

                Knob { extern: suboscill.extern + "Volume" 
                       type: :float
                }
                Knob { extern: suboscill.extern + "PPanning" }
                Knob { extern: suboscill.extern + "AmpVelocityScaleFunction"
                       type: :float
                 }
            }
            Widget {}
        }
        ZynAmpEnv {
            extern: suboscill.extern+"AmpEnvelope/"
        }
        function layout(l, selfBox) {
            Draw::Layout::hpack(l, selfBox, children)
        }
    }

    function layout(l, selfBox) {
        Draw::Layout::vfill(l, selfBox, children, [0.6, 0.4])
    }

}

