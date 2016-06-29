Widget {
    id: enveditor
    Envelope {
        id: env
        extern: enveditor.extern
    }
    Col {
        spacer: 8
        Button { label: "free" }
        Button { label: "add"  }
        Button { label: "delete" }
        Knob   { label: "sustain" }
        Text   { label: "1.47 sec" }
    }

    function layout(l) {
        Draw::Layout::hfill(l, self_box(l), chBoxes(l), [0.85, 0.15], 0, 3)
    }

    //Activate Envelope
    function onSetup(old=nil)
    {
        env.extern()
    }
}
