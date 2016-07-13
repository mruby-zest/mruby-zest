Group {
    id: echo
    label: "echo"
    topSize: 0.2

    ParModuleRow {
        Knob { extern: echo.extern + "pan" }

        Knob { extern: echo.extern + "Echo/Pdelay"   }
        Knob { extern: echo.extern + "Echo/Plrdelay" }
        Knob { extern: echo.extern + "Echo/Plrcross" }
        Knob { extern: echo.extern + "Echo/Pfb" }
        Knob { extern: echo.extern + "Echo/Phidamp" }
    }
}
