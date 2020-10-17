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
        Knob { 
            whenValue: lambda { box.cb }; 
            extern: box.extern+"A_dt"
            type:   :float
        }
        Knob { 
            whenValue: lambda { box.cb }; 
            extern: box.extern+"D_dt"
            type:   :float
        }
        Knob { 
            whenValue: lambda { box.cb }; 
            extern: box.extern+"R_dt"
            type:   :float
        }
        Col {
            ToggleButton { label: "FRCR"; whenValue: lambda { box.cb }; extern: box.extern+"Pforcedrelease"}
            ToggleButton   { label: "repeat"; whenValue: lambda { box.cb }; extern: box.extern+"Prepeating"}
        }
    }
    ParModuleRow {
        id: bot
        Knob { whenValue: lambda { box.cb }; extern: box.extern+"PA_val"}
        Knob { whenValue: lambda { box.cb }; extern: box.extern+"PD_val"}
        Knob { whenValue: lambda { box.cb }; extern: box.extern+"PR_val"}
        Knob { whenValue: lambda { box.cb }; extern: box.extern+"Penvstretch"}
    }
}
