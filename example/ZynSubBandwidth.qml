Widget {
    id: subbw
    extern: "/part0/kit0/subpars/"
    //visual
    ZynEnvEdit {
        extern: subbw.extern + "BandWidthEnvelope/"
    }
    Widget {
        Group {
            label: "general"
            ParModuleRow {
                Selector { extern: subbw.extern + "Phmagtype" }
                Selector { extern: subbw.extern + "Pstart" }
                Button { label: "clear" }
                Selector { extern: subbw.extern + "Pnumstages" }
            }
            ParModuleRow {
                Knob { extern: subbw.extern + "Pbandwidth" }
                Knob { extern: subbw.extern + "Pbwscale" }
            }
        }
        Group {label: "envelope"}
        function layout(l) {
            Draw::Layout::hpack(l, self_box(l), chBoxes(l))
        }
    }
    function layout(l) {
        Draw::Layout::vfill(l, self_box(l), chBoxes(l), [0.6, 0.4])
    }
}
