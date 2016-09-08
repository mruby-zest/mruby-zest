Widget {
    id: foot
    function class_name() {"ZynFooter"}
    Indent {
        id: wheelwell
        ModWheel {
            value: 0
            label: "wheel"
            tooltip: "modulation wheel"
            whenValue: lambda {
                $remote.action("/setController", 0, 1, (wheelwell.children[0].value*127).to_i)
            }

        }

        function layout(l)
        {
            selfBox = l.genBox :modwheelwell, self
            whelBox = self.children[0].layout l

            l.fixed(whelBox, selfBox, 0.1, 0.1, 0.8, 0.8)
            selfBox
        }
    }

    Keyboard {
        id: key
    }

    ParModuleRow {
        id: ctrl
        layoutOpts: []
        Knob {
            id: vel
            whenValue: lambda { key.velocity = vel.value*127 }
            value: 0.7;
            label: "velocity"
        }
        Knob {
            id: rnd
            whenValue: lambda { key.velrnd = rnd.value*127 }
            value: 0.2;
            label: "vrnd"
        }
        Knob { value: 0.5; label: "octave" }
        Selector {
            options: ["qwerty"]
            layoutOpts: {:weight=>0.2}
        }
        Knob     {
            id: cc
            label: "c.val"
            whenValue: lambda { foot.set_cc((cc.value*127).to_i) }
        }
        Selector {
            id: cctype
            label: "MIDI CC"
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

    function layout(l)
    {
        selfBox = l.genBox :footer, self
        whelBox = wheelwell.layout l
        keybBox = key.layout l
        ctrlBox = ctrl.layout l

        l.fixed(whelBox, selfBox, 0.010, 0.15, 0.017, (1-2*0.15))
        l.fixed(keybBox, selfBox, 0.032, 0.10, 0.536, 0.8)
        l.fixed(ctrlBox, selfBox, 0.600, 0.05, 0.400, 0.9)
        selfBox
    }
}
