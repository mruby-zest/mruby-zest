Group {
    id: wah
    label: "alienwah"
    topSize: 0.2

    ParModuleRow {
        Knob { extern: wah.extern + "Pvolume"}
        Knob { extern: wah.extern + "Ppanning"}

        Knob { extern: wah.extern + "Alienwah/Pfreq"   }
        Knob { extern: wah.extern + "Alienwah/Pfreqrnd"   }
        Selector     { extern: wah.extern + "Alienwah/PLFOtype" }
        ToggleButton { extern: wah.extern + "Alienwah/PStereo" }
        Knob { extern: wah.extern + "Alienwah/Pdepth" }
        Knob { extern: wah.extern + "Alienwah/Pfeedback" }
        Knob { extern: wah.extern + "Alienwah/Pdelay" }
        Knob { extern: wah.extern + "Alienwah/Plrcross" }
        Knob { extern: wah.extern + "Alienwah/Pphase" }
    }
}
