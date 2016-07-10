Group {
    id: port
    label: "portamento"
    copyable: false
    ParModuleRow {
        Button { extern: port.extern+"portamento.receive"}
        Button { extern: port.extern+"portamento.pitchthreshtype"}
        Knob   { extern: port.extern+"portamento.pitchthresh"}
        Knob   { extern: port.extern+"portamento.time"}
        Knob   { extern: port.extern+"portamento.updowntimestretch"}
    }
    ParModuleRow {
        Button { extern: port.extern+"portamento.proportional"}
        Knob   { extern: port.extern+"portamento.propRate"}
        Knob   { extern: port.extern+"portamento.propDepth"}
    }
}
