Widget {
    id: foot
    function class_name() {"ZynFooter"}
    Indent {
        id: wheelwell
        ModWheel { label: "wheel" }

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
        Knob { label: "velocity" }
        Knob { label: "vrnd" }
        Knob { label: "octave" }
        Knob { label: "querty" }
        Knob { label: "qwerty" }
        Knob { label: "c.val" }
        Selector { label: "MIDI CC" }
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
