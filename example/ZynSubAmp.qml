Widget {
    id: subamp
    extern: "/part0/kit0/subpars/"
    //visual
    ZynEnvEdit {
        id: edit
        extern: subamp.extern + "AmpEnvelope/"
    }
    Widget {
        Group {
            label: "general"
            ParModuleRow {
                ToggleButton { extern: subamp.extern + "Pstereo" }

                Knob { extern: subamp.extern + "PVolume" }
                Knob { extern: subamp.extern + "PPanning" }
                Knob { extern: subamp.extern + "AmpVelocityScaleFunction"
                       type: :float
                 }
            }
            Widget {}
        }
        ZynAmpEnv {
            extern: subamp.extern+"AmpEnvelope/"
            whenModified: lambda { edit.refresh }
        }
        function layout(l, selfBox) {
            Draw::Layout::hpack(l, selfBox, children)
        }
    }
    function layout(l, selfBox) {
        Draw::Layout::vfill(l, selfBox, children, [0.6, 0.4])
    }
}
