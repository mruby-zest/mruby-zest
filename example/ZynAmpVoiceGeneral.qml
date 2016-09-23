Group {
    id: box
    label: "General"
    copyable: false

    ParModuleRow {
        id: top
        Knob { extern: box.extern+"PVolume" }
        Knob { extern: box.extern+"PAmpVelocityScaleFunction"}
        ToggleButton { extern: box.extern+"Pfilterbypass" }

    }
    ParModuleRow {
        id: bot
        Knob { extern: box.extern+"PPanning"}
        Knob { extern: box.extern+"PDelay"}
        ToggleButton   {label: "reson";  extern: box.extern+"Presonance"}
    }
}
