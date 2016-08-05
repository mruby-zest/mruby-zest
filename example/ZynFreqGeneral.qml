Group {
    id: box
    label: "General"
    extern: "/part0/kit0/adpars/GlobalPar/"
    ParModuleRow {
        Knob { extern: box.extern + "PDetune" }
        NumEntry { extern: box.extern + "octave" }
        Knob { extern: box.extern + "PBandwidth" }
    }

    ParModuleRow {
        Selector { extern: box.extern + "PDetuneType" }
        Knob { extern: box.extern + "PCoarseDetune" }
    }
}
