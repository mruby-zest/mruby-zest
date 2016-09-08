Group {
    id: box
    label: "General"
    property Function whenModified: nil
    ParModuleRow {
        Knob { extern: box.extern + "PDetune" }
        NumEntry { extern: box.extern + "octave" }
    }

    ParModuleRow {
        Selector { extern: box.extern + "PDetuneType" }
        Knob { extern: box.extern + "PCoarseDetune" }
    }
}
