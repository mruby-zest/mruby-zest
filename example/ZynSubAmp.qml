Widget {
    id: subamp
    extern: "/part0/kit0/subpars/"
    //visual
    ZynEnvEdit {
        extern: subamp.extern + "AmpEnvelope/"
    }
    Widget {
        Group {
            label: "general"
            ParModuleRow {
                ToggleButton { extern: subamp.extern + "Pstereo" }

                Knob { extern: subamp.extern + "PVolume" }
                Knob { extern: subamp.extern + "PPanning" }
                Knob { extern: subamp.extern + "PAmpVelocityScaleFunction" }
            }
        }
        ZynAmpEnv {extern: subamp.extern+"AmpEnvelope/"}
        function layout(l) {
            Draw::Layout::hpack(l, self_box(l), chBoxes(l))
        }
    }
    function layout(l) {
        Draw::Layout::vfill(l, self_box(l), chBoxes(l), [0.6, 0.4])
    }
}
