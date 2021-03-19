Group {
    id: box
    label: "SEQ"
    extern: ""
    copyable: true

    ParModuleRow {
        id: top
        Knob {extern: box.extern+"steps"}
        Knob { type: :float; extern: box.extern+"freq" }
        Knob { type: :float; extern: box.extern+"cutoff"}
        ToggleButton   { label: "sync"; extern: box.extern+"continous"}
    }
    ParModuleRow {
        id: bot
        Knob { type: :float; extern: box.extern+"delay"}
        Knob { type: :float; extern: box.extern+"intensity" }
        Knob { type: :float; extern: box.extern+"speedratio"}
        Selector { extern: box.extern+"ratiofixed"}

    }
}
