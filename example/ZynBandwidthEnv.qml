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
        Knob { 
            whenValue: lambda { box.cb }; 
            extern: box.extern+"A_dt"
            type:   :float
        }
        Knob     { 
            whenValue: lambda { box.cb }; 
            extern: box.extern+"R_dt"
            type:   :float
        }
        Knob { whenValue: lambda { box.cb }; extern: box.extern+"PR_val"}
    }
    ParModuleRow {
        id: bot
        Knob     { whenValue: lambda { box.cb }; extern: box.extern+"Penvstretch"}
        ToggleButton   { label: "FRCR"; whenValue: lambda { box.cb }; extern: box.extern+"Pforcedrelease"}
    }
}
