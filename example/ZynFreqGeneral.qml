Group {
    id: box
    label: "General"
    extern: "/part0/kit0/adpars/GlobalPar/"
    ParModuleRow {
        Knob { extern: box.extern + "PDetune" }
        Knob { extern: box.extern + "Poctave" }
        Knob { extern: box.extern + "Prelbw" }
    }

    ParModuleRow {
        Selector { extern: box.extern + "PdetuneType" }
        Knob { extern: box.extern + "PcoarseDetune" }
    }
}
