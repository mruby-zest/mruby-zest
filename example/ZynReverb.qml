Group {
    id: reverb
    label: "reverb"
    topSize: 0.2
    ParModuleRow {
        Knob { extern: reverb.extern + "Pvolume"}
        Knob { extern: reverb.extern + "Ppanning"}

        Selector { extern: reverb.extern + "Reverb/Ptype"}
        Knob { extern: reverb.extern + "Reverb/Proomsize" }
        Knob { extern: reverb.extern + "Reverb/Ptime" }
        Knob { extern: reverb.extern + "Reverb/Pidelay"}
        Knob { extern: reverb.extern + "Reverb/Pidelayfb"}
        Knob { extern: reverb.extern + "Reverb/Plpf"}
        Knob { extern: reverb.extern + "Reverb/Phpf"}
        Knob { extern: reverb.extern + "Reverb/Plohidamp"}
        Knob { extern: reverb.extern + "Reverb/Pbandwidth" }
    }
}
