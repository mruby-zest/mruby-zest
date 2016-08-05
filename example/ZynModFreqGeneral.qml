Group {
    id: box
    extern: ""
    ParModuleRow {
        Knob { extern: box.extern + "PFMDetune" }
        NumEntry { extern: box.extern + "PFMoctave" }
        Knob { extern: box.extern + "PFMrelbw" }
        Selector { extern: box.extern + "PFMdetuneType" }
        NumEntry { extern: box.extern + "PFMcoarseDetune" }
    }
}
