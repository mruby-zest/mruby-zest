Group {
    id: box
    label: "General"
    extern: "/part0/kit0/adpars/"
    copyable: false

    ParModuleRow {
        id: top
        Knob { extern: box.extern+"GlobalPar/PVolume" }
        Knob { extern: box.extern+"GlobalPar/PAmpVelocityScaleFunction"}
        Knob { extern: box.extern+"GlobalPar/PPanning"}
        Knob { extern: box.extern+"GlobalPar/PPunchStretch"}

    }
    ParModuleRow {
        id: bot
        Knob     {extern: box.extern+"GlobalPar/PPunchStrength"}
        Knob     {extern: box.extern+"GlobalPar/PPunchTime"}
        Col {
            Button   {label: "stereo"; extern: box.extern+"GlobalPar/Pstereo"}
            Button   {label: "rnd grp"}
        }
    }
}
