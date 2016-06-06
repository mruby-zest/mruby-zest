Group {
    label: "instrument settings"
    ParModuleRow {
        Knob {label: "vol"}
        Knob {label: "pan"}
        Knob {label: "sense"}
        Knob {label: "offset"}
        Knob {label: "key shift"}
    }
    ParModuleRow {
        Selector { label: "mode" }
        Button   { label: "note on"}
        Button   { label: "portamento"}
    }
    ParModuleRow {
        Selector { label: "k.lmt" }
        Selector { label: "midi channel"}
        Knob     { label: "min" }
        Button   { label: "m" }
        Button   { label: "r" }
        Button   { label: "m" }
        Knob     { label: "max"}
    }
}
