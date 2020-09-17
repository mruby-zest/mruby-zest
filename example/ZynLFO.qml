Group {
    id: box
    label: "LFO"
    extern: ""
    copyable: true

    ParModuleRow {
        id: top
        Knob { type: :float; extern: box.extern+"freq" }
        Knob { extern: box.extern+"Pintensity"}
        Knob { extern: box.extern+"Pstartphase"}
        Knob { extern: box.extern+"Pstretch"}

    }
    ParModuleRow {
        id: bot
        Knob     { type: :float; extern: box.extern+"delay"}
        Knob     {extern: box.extern+"Prandomness"}
        Knob     {extern: box.extern+"Pfreqrand"}
        Col {
            Selector {extern: box.extern+"PLFOtype"}
            ToggleButton   { label: "sync"; extern: box.extern+"Pcontinous"}
        }
    }
}
