Group {
    //TODO TODO
    id: box
    label: "Envelope"
    property String extern: "/part0/kit0/adpars/GlobalPar/AmpEnvelope/"

    ParModuleRow {
        id: top
        Knob { extern: box.extern+"PA_dt" }
        Knob { extern: box.extern+"PD_dt"}
        Knob { extern: box.extern+"PS_val"}

    }
    ParModuleRow {
        id: bot
        Knob     {extern: box.extern+"PR_dt"}
        Knob     {extern: box.extern+"Penvstretch"}
        Col {
            Button   {extern: box.extern+"Pforcedrelease"}
            Button   {extern: box.extern+"Plinearenvelope"}
        }
    }
}
