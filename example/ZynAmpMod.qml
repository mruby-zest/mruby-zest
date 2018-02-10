Group {
    id: box
    label: "General"
    copyable: false

    ParModuleRow {
        Knob {
            type:   :float
            extern: box.extern + "FMvolume"
        }
        Knob { extern: box.extern+"PFMVolumeDamp"}
        Knob { extern: box.extern+"PFMVelocityScaleFunction"}

    }
    Widget {}
}
