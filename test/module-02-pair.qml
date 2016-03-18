Window {
    id: win
    label: "module-02-pair"
    function layout(l)
    {
        puts "Window Layout..."
        sb = l.genBox :window, win
        mt = modTop.layout(l)
        mb = modBot.layout(l)
        l.contains(sb, mt)
        l.contains(sb, mb)
        l.topOf(mt,mb)
        l.sheq([mb.h, mt.h], [1, -1], 0)
        sb
    }
    Module {
        id: modTop
        label: "module-01-layout"
        w: 1200
        h: 400
        Knob {label: "knob1"}
        Knob {label: "knob1"}
        Knob {label: "knob1"}
        Knob {label: "knob1"}
        Knob {label: "knob1"}
        Knob {label: "knob1"}
        Slider {label: "slider1"}
        Knob {label: "knob2"}
        Knob {label: "knob3"}
        Slider {label: "slider2"}
    }
    Module {
        id: modBot
        label: "module-01-layout"
        w: 1200
        h: 400
        Knob {}
        Slider {}
        Knob {}
        Knob {}
        Slider {label: "slider4"}
    }
}
