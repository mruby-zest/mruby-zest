Group {
    id: dst
    label: "distortion"
    topSize: 0.2
    ParModuleRow {
        Knob { extern: dst.extern + "Pvolume"}
        Knob { extern: dst.extern + "Ppanning"}

        Selector {   extern: dst.extern + "Distorsion/Ptype"; }
        Knob {   extern: dst.extern + "Distorsion/Plrcross"; label: "l.rc." }
        Knob {   extern: dst.extern + "Distorsion/Pdrive"; label: "drive" }
        Knob {   extern: dst.extern + "Distorsion/Plevel"; label: "level" }
        Knob {   extern: dst.extern + "Distorsion/Plpf"}
        Knob {   extern: dst.extern + "Distorsion/Phpf"}
        ToggleButton { extern: dst.extern + "Distorsion/Pprefiltering"}
        ToggleButton { extern: dst.extern + "Distorsion/Pstereo"}
    }
}
