Group {
    id: chorus
    label: "chorus"
    topSize: 0.2

    ParModuleRow {
        Knob { extern: chorus.extern + "pan" }
        Knob { extern: chorus.extern + "Chorus/Pfreq" }
        Knob { extern: chorus.extern + "Chorus/Pfreqrnd" }
        Knob { extern: chorus.extern + "Chorus/PLFOtype" }
        ToggleButton { extern: chorus.extern + "Chorus/PStereo" }
        Knob { extern: chorus.extern + "Chorus/Pdepth" }
        Knob { extern: chorus.extern + "Chorus/Pdelay" }
        Knob { extern: chorus.extern + "Chorus/Pfeedback" }
        Knob { extern: chorus.extern + "Chorus/Plrcross" }
        ToggleButton { extern: chorus.extern + "Chorus/Pflangemode" }
        ToggleButton { extern: chorus.extern + "Chorus/Poutsub" }
    }
}

