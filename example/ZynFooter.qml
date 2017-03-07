Widget {
    id: foot
    function class_name() {"ZynFooter"}
    Indent {
        id: wheelwell
        ModWheel {
            id: wheel
            value: 0
            label: "wheel"
            tooltip: "modulation wheel"
            whenValue: lambda {
                $remote.action("/setController", 0, 1, (wheelwell.children[0].value*127).to_i)
            }

        }

        function layout(l, selfBox) {
            wheel.fixed(l, selfBox, 0.1, 0.1, 0.8, 0.8)
            selfBox
        }
    }

    Keyboard {
        id: key
        velocity: 0.7*127
        velrnd:   0.2*127
    }

    ParModuleRow {
        id: ctrl
        layoutOpts: []
        Knob {
            id: vel
            whenValue: lambda { key.velocity = vel.value*127 }
            value: 0.7;
            label: "velocity"
            tooltip: "velocity of virtual keyboard notes"
        }
        Knob {
            id: rnd
            whenValue: lambda { key.velrnd = rnd.value*127 }
            value: 0.2;
            label: "vrnd"
            tooltip: "velocity randomness of virtual keyboard notes"
        }
        Knob { value: 0.5; label: "octave" }
        Knob     {
            id: cc
            label: "c.val"
            whenValue: lambda { foot.set_cc((cc.value*127).to_i) }
            tooltip: "midi CC control"
        }
        Selector {
            id: cctype
            label: "MIDI CC"
            tooltip: "midi CC selector"
            layoutOpts: {:weight=>2.0, :long_mode=>true}
            options: [ "01: Mod.Wheel",
                       "07: Volume",
                       "10: Panning",
                       "11: Expression",
                       "64: Sustain",
                       "65: Portamento",
                       "71: Filter Q",
                       "74: Filter Freq.",
                       "75: Bandwidth",
                       "76: FM Gain",
                       "77: Res. c. freq",
                       "78: Res. bw."]
        }
    }

    function set_cc(x)
    {
        cc_num =  cctype.options[cctype.selected].to_i
        $remote.action("/setController", 0, cc_num, x)

    }

    function layout(l, selfBox) {
        wheelwell.fixed(l,  selfBox, 0.010, 0.15, 0.017, (1-2*0.15))
        key.fixed(l,        selfBox, 0.032, 0.10, 0.536, 0.8)
        ctrl.fixed(l,       selfBox, 0.600, 0.05, 0.400, 0.9)
        selfBox
    }
}
