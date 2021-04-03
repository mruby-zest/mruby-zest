Group {
    id: echo
    label: "echo"
    topSize: 0.2
    function refresh() {
        return if rw.content.nil?
        return if rw.content.children.length < 4
        rw.content.children[3..-1].each do |c|
            c.refresh
        end
    }

    ParModuleRow {
        id: rw
        layoutOpts: []
        Selector {
            layoutOpts: [:long_mode]
            extern: echo.extern + "Echo/preset"
            whenValue: lambda { echo.refresh }
        }
        Knob { extern: echo.extern + "Pvolume"}
        Knob { extern: echo.extern + "Ppanning"}

        Knob { extern: echo.extern + "Echo/Pdelay"   }
        Selector { extern: echo.extern+"ratiofixed"}
        Knob { extern: echo.extern + "Echo/Plrdelay" }
        Knob { extern: echo.extern + "Echo/Plrcross" }
        Knob { extern: echo.extern + "Echo/Pfb" }
        Knob { extern: echo.extern + "Echo/Phidamp" }
    }
}
