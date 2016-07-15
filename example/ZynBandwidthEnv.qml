Group {
    id: box
    label: "Envelope"
    property Function whenModified: nil

    function cb()
    {
        whenModified.call if whenModified
    }

    ParModuleRow {
        id: top
        Knob { whenValue: lambda { box.cb }; extern: box.extern+"PA_val" }
        Knob { whenValue: lambda { box.cb }; extern: box.extern+"PA_dt" }
        Knob { whenValue: lambda { box.cb }; extern: box.extern+"PR_dt"}
        Knob { whenValue: lambda { box.cb }; extern: box.extern+"PR_val"}
    }
    ParModuleRow {
        id: bot
        Knob     { whenValue: lambda { box.cb }; extern: box.extern+"Penvstretch"}
        Button   { label: "FRCR"; whenValue: lambda { box.cb }; extern: box.extern+"Pforcedrelease"}
    }
}
