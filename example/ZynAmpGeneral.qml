Group {
    id: box
    label: "General"
    extern: "/part0/kit0/adpars/"

    ParModuleRow {
        id: top
        Knob { extern: box.extern+"GlobalPar/PVolume" }
        Knob { extern: box.extern+"GlobalPar/PAmpVelocityScaleFunction"}
        Knob { extern: box.extern+"GlobalPar/Ppanning"}
        Knob { extern: box.extern+"GlobalPar/PPunchstretch"}

    }
    ParModuleRow {
        id: bot
        Knob     {extern: box.extern+"GlobalPar/PPunchStrength"}
        Knob     {extern: box.extern+"GlobalPar/PPunchTime"}
        Col {
            Button   {extern: box.extern+"GlobalPar/Pstereo"}
            Button   {label: "rnd grp"}
        }
    }
}
