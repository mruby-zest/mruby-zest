Group {
    id: echo
    label: "echo"
    topSize: 0.2

    ParModuleRow {
        Knob { extern: echo.extern + "pan" }

        Knob { extern: echo.extern + "echo/Pdelay"   }
        Knob { extern: echo.extern + "echo/Plrdelay" }
        Knob { extern: echo.extern + "echo/Plrcross" }
        Knob { extern: echo.extern + "echo/Pfb" }
        Knob { extern: echo.extern + "echo/Phidamp" }
    }
}
