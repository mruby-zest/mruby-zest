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
                NumEntry { extern: subbw.extern + "Pnumstages" }
                Knob { extern: subbw.extern + "Pbandwidth" }
                Knob { extern: subbw.extern + "Pbwscale" }
            }
            Widget {
            }
        }
        ZynBandwidthEnv {
            toggleable: subbw.extern + "PBandWidthEnvelopeEnabled"
            whenModified: lambda {edit.refresh}
            extern: subbw.extern + "BandWidthEnvelope/"
        }
        function layout(l, selfBox) {
            Draw::Layout::hpack(l, selfBox, children)
        }
    }
    function layout(l, selfBox) {
        Draw::Layout::vfill(l, selfBox, children, [0.6, 0.4])
    }
}
