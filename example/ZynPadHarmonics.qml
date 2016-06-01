Widget {
    id: base
    extern: "/part0/kit0/padpars/"
    Widget {
        HarmonicView {
        }
        Group {
            ParModuleRow {
                Knob {}
                Selector {}
                Selector {extern: base.extern + "Pmode"}
            }
            ParModuleRow {
                Selector {}
                Knob {}
                Knob {}
                Knob {}
            }
        }
        function layout(l) {
            selfBox = l.genBox :tmp, self
            chiaBox = children[0].layout(l)
            chibBox = children[1].layout(l)
            l.fixed(chiaBox, selfBox, 0.0, 0.0, 0.6, 1.0)
            l.fixed(chibBox, selfBox, 0.6, 0.0, 0.4, 1.0)
            selfBox
        }
    }
    Widget {
        WaveView {
        }
        Group {
            label: "harmonic profile"
            ParModuleRow {
                Selector { extern: base.extern + "Php.base.type"}
                Selector { extern: base.extern + "Php.onehalf"}
                Button   {}
            }
            ParModuleRow {
                Knob {}
                Knob {}
                Knob {}
                Knob {}
                Knob {}
            }
            ParModuleRow {
                Selector { extern: base.extern + "Php.amp.type"}
                Selector { extern: base.extern + "Php.amp.mode"}
                Knob {}
                Knob {}
            }
        }
        function layout(l) {
            selfBox = l.genBox :tmp, self
            chiaBox = children[0].layout(l)
            chibBox = children[1].layout(l)
            l.fixed(chiaBox, selfBox, 0.0, 0.0, 0.6, 1.0)
            l.fixed(chibBox, selfBox, 0.6, 0.0, 0.4, 1.0)
            selfBox
        }
    }
    Widget {
        WaveView {
        }
        Group {
            label: "harmonic content"
            ParModuleRow {
                Selector {}
                Selector {}
                Selector {}
            }
            Text {label: "asdf"}
            Selector {}
        }
        function layout(l) {
            selfBox = l.genBox :tmp, self
            chiaBox = children[0].layout(l)
            chibBox = children[1].layout(l)
            l.fixed(chiaBox, selfBox, 0.0, 0.0, 0.6, 1.0)
            l.fixed(chibBox, selfBox, 0.6, 0.0, 0.4, 1.0)
            selfBox
        }
    }

    function layout(l) {
        selfBox = l.genBox :tmp, self
        chiaBox = children[0].layout(l)
        chibBox = children[1].layout(l)
        chicBox = children[2].layout(l)
        l.fixed(chiaBox, selfBox, 0.0, 0.00, 1.0, 0.33)
        l.fixed(chibBox, selfBox, 0.0, 0.33, 1.0, 0.33)
        l.fixed(chicBox, selfBox, 0.0, 0.66, 1.0, 0.34)
        selfBox
    }
}
