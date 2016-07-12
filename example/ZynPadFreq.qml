Group {
    id: box
    label: "General"
    ParModuleRow {
        Knob { extern: box.extern + "PDetune" }
        Knob { extern: box.extern + "octave" }
        Knob { extern: box.extern + "PBandwidth" }
    }

    ParModuleRow {
        Selector { extern: box.extern + "PDetuneType" }
        Knob { extern: box.extern + "PCoarseDetune" }
    }
}
