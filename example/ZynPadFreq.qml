Group {
    id: box
    label: "General"
    property Function whenModified: nil
    ParModuleRow {
        Knob { extern: box.extern + "PDetune" }
        NumEntry { extern: box.extern + "octave" }
        Knob { extern: box.extern + "Pbandwidth" }
    }

    ParModuleRow {
        ToggleButton {extern: box.extern + "Pfixedfreq" }
        Knob { extern: box.extern + "PfixedfreqET" }
        Selector { extern: box.extern + "PDetuneType" }
        NumEntry { extern: box.extern + "PCoarseDetune" }
    }
}
