Group {
    id: box
    label: "Envelope"
    property Function whenModified: nil
    extern: ""

    function cb()
    {
        whenModified.call if whenModified
    }

    ParModuleRow {
        id: top
        Knob { whenValue: lambda { box.cb }; extern: box.extern+"PA_dt" }
        Knob { whenValue: lambda { box.cb }; extern: box.extern+"PD_dt" }
        Knob { whenValue: lambda { box.cb }; extern: box.extern+"PR_dt" }
    }
    ParModuleRow {
        id: bot
        Knob { whenValue: lambda { box.cb }; extern: box.extern+"PS_val"}
        Knob { whenValue: lambda { box.cb }; extern: box.extern+"Penvstretch" }
        Button { label: "FRCR"; whenValue: lambda { box.cb }; extern: box.extern+"Pforcedrelease"}
    }
}
