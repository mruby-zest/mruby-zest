Group {
    id: box
    label: "General"
    ParModuleRow {
        Knob { extern: box.extern + "PDetune" }
        Knob { extern: box.extern + "octave" }
        Knob { extern: box.extern + "Pbandwidth" }
    }

    ParModuleRow {
        ToggleButton {extern: box.extern + "Pfixedfreq" }
        Knob { extern: box.extern + "PfixedfreqET" }
        Selector { extern: box.extern + "PDetuneType" }
        Knob { extern: box.extern + "PCoarseDetune" }
    }
}
