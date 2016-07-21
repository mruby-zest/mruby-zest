Widget {
    id: subbw
    extern: "/part0/kit0/subpars/"
    //visual
    ZynEnvEdit {
        id: edit
        extern: subbw.extern + "BandWidthEnvelope/"
    }
    Widget {
        Group {
            label: "general"
            ParModuleRow {
                Selector { extern: subbw.extern + "Pstart" }
                Selector { extern: subbw.extern + "Pnumstages" }
            }
            ParModuleRow {
                Knob { extern: subbw.extern + "Pbandwidth" }
                Knob { extern: subbw.extern + "Pbwscale" }
            }
        }
        ZynBandwidthEnv {
            toggleable: subbw.extern + "PBandWidthEnvelopeEnabled"
            whenModified: lambda {edit.refresh}
            extern: subbw.extern + "BandWidthEnvelope/"
        }
        function layout(l) {
            Draw::Layout::hpack(l, self_box(l), chBoxes(l))
        }
    }
    function layout(l) {
        Draw::Layout::vfill(l, self_box(l), chBoxes(l), [0.6, 0.4])
    }
}
