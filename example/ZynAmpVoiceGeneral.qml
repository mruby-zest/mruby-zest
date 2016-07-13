Group {
    id: box
    label: "General"
    copyable: false

    ParModuleRow {
        id: top
        Knob { extern: box.extern+"PVolume" }
        Knob { extern: box.extern+"PAmpVelocityScaleFunction"}
        Knob { extern: box.extern+"PPanning"}
        Knob { extern: box.extern+"PDelay"}

    }
    ParModuleRow {
        id: bot
        ToggleButton   {label: "stereo"; extern: box.extern+"Pstereo"}
        ToggleButton   {label: "reson";  extern: box.extern+"Presonance"}
    }
}
