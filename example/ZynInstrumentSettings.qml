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
        Selector { label: "mode"; layoutOpts: [:no_constraint]  }
        Button   { label: "note on"}
        Button   { label: "portamento"}
    }
    ParModuleRow {
        Selector { label: "k.lmt" }
        Selector { label: "midi channel"}
        Knob     { label: "min" }
        Button   { label: "m"; layoutOpts: [:no_constraint] }
        Button   { label: "r"; layoutOpts: [:no_constraint] }
        Button   { label: "m"; layoutOpts: [:no_constraint] }
        Knob     { label: "max"}
    }
}
