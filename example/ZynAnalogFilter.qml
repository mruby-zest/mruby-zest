Group {
    id: box
    label: "General"
    extern: "/part0/kit0/adpars/GlobalPar/GlobalFilter/"
    property Function whenModified: nil
    function cb()
    {
        whenModified.call if whenModified
    }
    ParModuleRow {
        Selector { whenValue: lambda { box.cb}; extern: box.extern + "Ptype" }
        Selector { extern: box.extern + "../PPdetuneType" }
        Knob {     extern: box.extern + "../PVelocityScale" }
    }
    ParModuleRow {
        Knob { whenValue: lambda { box.cb};  extern: box.extern     + "Pfreq" }
        Knob { whenValue: lambda { box.cb};  extern: box.extern     + "Pq" }
        Knob { whenValue: lambda { box.cb};  extern: box.extern     + "Pfreqtrack" }
        Knob { whenValue: lambda { box.cb};  extern: box.extern     + "Pgain" }
        Selector {
            //layoutOpts: [:no_constraint]
            whenValue: lambda { box.cb}
            extern: box.extern + "Pstages"
        }
    }

}
