Group {
    id: box
    label: "General"
    copyable: false
    property Function whenModified: nil

    ParModuleRow {
        id: top
        Knob { extern: box.extern+"PVolume" }
        Knob { extern: box.extern+"PAmpVelocityScaleFunction"}
        Knob { extern: box.extern+"PPanning"}
        Knob { extern: box.extern+"PPunchStretch"}

    }
    ParModuleRow {
        id: bot
        Knob     {extern: box.extern+"PPunchStrength"}
        Knob     {extern: box.extern+"PPunchTime"}
        Col {
            Button   {label: "stereo"; extern: box.extern+"Pstereo"}
            Button   {label: "rnd grp"}
        }
    }
}
