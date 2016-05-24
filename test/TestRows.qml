Group {
    id: box
    label: "LFO"
    property String extern: "/part0/kit0/adpars/GlobalPar/FreqLfo/"

    //function layout(l)
    //{
    //    selfBox = l.genBox :test, box
    //    topBox  = top.layout(l)
    //    botBox  = bot.layout(l)
    //    l.contains(selfBox, topBox)
    //    l.contains(selfBox, botBox)
    //    l.topOf(topBox, botBox)
    //    l.sheq([topBox.h, selfBox.h], [1, -0.5], 0)
    //    selfBox
    //}
    ParModuleRow {
        id: top
        Knob { extern: box.extern+"Pfreq" }
        Knob { extern: box.extern+"Pintensity"}
        Knob { extern: box.extern+"Pstartphase"}
        Knob { extern: box.extern+"Pstretch"}

    }
    ParModuleRow {
        id: bot
        Knob     {extern: box.extern+"Prandomness"}
        Knob     {extern: box.extern+"Pfreqrand"}
        Col {
            Selector {extern: box.extern+"PLFOtype"}
            Button   {extern: box.extern+"Pcontinous"; label: "C"}
        }
    }
}
