Group {
    id: box
    label: "General"
    //extern: "/part0/kit0/adpars/GlobalPar/GlobalFilter/"
    property Function whenModified: nil
    property Bool     type: :analog

    onType: {
        #Changes filter type
    }

    function cb()
    {
        whenModified.call if whenModified
    }

    ParModuleRow {
        Knob { whenValue: lambda { box.cb};  extern: box.extern     + "Pfreq" }
        Knob { whenValue: lambda { box.cb};  extern: box.extern     + "Pq" }
        Knob { whenValue: lambda { box.cb};  extern: box.extern     + "Pfreqtrack" }
        Knob { extern: box.extern + "../PFilterVelocityScale" }
        Knob { extern: box.extern + "../PFilterVelocityScaleFunction" }
    }
    ParModuleRow {
        NumEntry {
            whenValue: lambda { box.cb}
            extern: box.extern + "Pstages"
            offset: 1
            minimum: 1
            maximum: 5
        }
        Selector { extern: box.extern + "Pcategory" }
        Selector { whenValue: lambda { box.cb}; extern: box.extern + "Ptype" }
        Knob { whenValue: lambda { box.cb};  extern: box.extern     + "Pgain" }
    }
}
