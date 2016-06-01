Group {
    id: box
    label: "General"
    extern: "/part0/kit0/adpars/GlobalPar/GlobalFilter/"
    ParModuleRow {
        Selector { extern: box.extern + "../PPdetuneType" }
        Knob { extern: box.extern + "../PVelocityScale" }
    }
    ParModuleRow {
        Knob { extern: box.extern     + "Pfreq" }
        Knob { extern: box.extern     + "Pq" }
        Knob { extern: box.extern     + "Pfreqtrack" }
        Knob { extern: box.extern     + "Pgain" }
        Selector { extern: box.extern + "Pstages" }
    }

}
