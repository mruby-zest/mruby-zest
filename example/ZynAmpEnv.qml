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
        Knob { whenValue: lambda { box.cb }; extern: box.extern+"PA_dt" }
        Knob { whenValue: lambda { box.cb }; extern: box.extern+"PD_dt"}
        Knob { whenValue: lambda { box.cb }; extern: box.extern+"PS_val"}
    }
    ParModuleRow {
        id: bot
        Knob     { whenValue: lambda { box.cb }; extern: box.extern+"PR_dt"}
        Knob     { whenValue: lambda { box.cb }; extern: box.extern+"Penvstretch"}
        Col {
            Button   { whenValue: lambda { box.cb }; extern: box.extern+"Pforcedrelease"}
            Button   { whenValue: lambda { box.cb }; extern: box.extern+"Plinearenvelope"}
        }
    }
}
