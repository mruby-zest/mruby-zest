Group {
    id: box
    extern: ""
    ParModuleRow {
        Knob { extern: box.extern + "PFMDetune" }
        Knob { extern: box.extern + "PFMoctave" }
        Knob { extern: box.extern + "PFMrelbw" }
        Selector { extern: box.extern + "PFMdetuneType" }
        Knob { extern: box.extern + "PFMcoarseDetune" }
    }
}
