Group {
    id: box
    label: "LFO"
    extern: ""

    ParModuleRow {
        id: top
        Knob { extern: box.extern+"Pfreq" }
        Knob { extern: box.extern+"Pintensity"}
        Knob { extern: box.extern+"Pstartphase"}
        Knob { extern: box.extern+"Pstretch"}

    }
    ParModuleRow {
        id: bot
        Knob     {extern: box.extern+"Pdelay"}
        Knob     {extern: box.extern+"Prandomness"}
        Knob     {extern: box.extern+"Pfreqrand"}
        Col {
            Selector {extern: box.extern+"PLFOtype"}
            Button   {extern: box.extern+"Pcontinous"; label: "sync"}
        }
    }
}
