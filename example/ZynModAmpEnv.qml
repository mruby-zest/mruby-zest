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
        
        Knob { whenValue: lambda { box.cb }; extern: box.extern+"PS_val"}
        Knob     { 
            whenValue: lambda { box.cb }; 
            extern: box.extern+"R_dt"
            type:   :float
        }
        Knob { whenValue: lambda { box.cb }; extern: box.extern+"Penvstretch"}
    }
}
