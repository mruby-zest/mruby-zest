Group {
    id: dst
    label: "distortion"
    topSize: 0.2
    ParModuleRow {
        Knob { label: "pan"}

        Selector {   extern: dst.extern + "Ptype"; }
        Knob {   extern: dst.extern + "Plrcross"; label: "l.rc." }
        Knob {   extern: dst.extern + "Distorsion/Pdrive"; label: "drive" }
        Knob {   extern: dst.extern + "Distorsion/Poutput"; label: "level" }
        Knob {   extern: dst.extern + "Distorsion/Plpf"}
        Knob {   extern: dst.extern + "Distorsion/Phpf"}
        ToggleButton { extern: dst.extern + "Distorsion/Pprefiltering"}
        ToggleButton { extern: dst.extern + "Distorsion/Pstereo"}
    }
}
