Group {
    id: box
    label: "General"
    copyable: false

    ParModuleRow {
        Knob { extern: box.extern+"PFMVolume" }
        Knob { extern: box.extern+"PFMVolumeDamp"}
        Knob { extern: box.extern+"PFMVelocityScaleFunction"}

    }
    Widget {}
}
