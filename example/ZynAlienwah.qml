Group {
    id: echo
    label: "alienwah"
    topSize: 0.2

    ParModuleRow {
        Knob { extern: echo.extern + "pan" }

        Knob { extern: echo.extern + "Alienwah/Pfreq"   }
        Knob { extern: echo.extern + "Alienwah/Pfreqrnd"   }
        Selector     { extern: echo.extern + "Alienwah/PLFOtype" }
        ToggleButton { extern: echo.extern + "Alienwah/PStereo" }
        Knob { extern: echo.extern + "Alienwah/Pdepth" }
        Knob { extern: echo.extern + "Alienwah/Pfb" }
        Knob { extern: echo.extern + "Alienwah/Pdelay" }
        Knob { extern: echo.extern + "Alienwah/Plrcross" }
        Knob { extern: echo.extern + "Alienwah/Pphase" }
    }
}
