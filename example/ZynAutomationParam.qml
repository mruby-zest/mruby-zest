Widget {
    ZynAutomationName {

    }
    Widget{
        PlotLabelY {}
        ZynAutomationPlot {id: plot}
        function layout(l, selfBox) {
            Draw::Layout::hfill(l, selfBox, children, [0.1, 0.9])
        }
    }
    ParModuleRow {
        Knob {
            value: 0.0
            label: "min"
        }
        Knob {
            value: 1.0
            label: "max"
        }
        Knob {
            id: gain
            label: "gain"
            value: 0.5
            whenValue: lambda {plot.set_gain(4*(gain.value-0.5))}
        }
        Knob {
            id: offset
            label: "offset"
            value: 0.5
            whenValue: lambda {plot.set_offset(offset.value-0.5)}
        }
    }

    function layout(l, selfBox) {
        Draw::Layout::vfill(l, selfBox, children, [0.1, 0.45, 0.35])
    }
}
