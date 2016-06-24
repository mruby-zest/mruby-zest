Widget {
    id: base
    extern: "/part0/kit0/padpars/"
    Widget {
        HarmonicView {
        }
        ZynPadOvertone {}
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
        VisHarmonic {
        }
        Group {
            label: "harmonic profile"
            topSize: 0.09

            ZynPadProfile { extern: base.extern}
        }
        function layout(l) {
            selfBox = l.genBox :tmp, self
            chiaBox = children[0].layout(l)
            chibBox = children[1].layout(l)
            l.fixed(chiaBox, selfBox, 0.0, 0.0, 0.7, 1.0)
            l.fixed(chibBox, selfBox, 0.7, 0.0, 0.3, 1.0)
            selfBox
        }
    }
    Widget {
        WaveView {
        }
        Group {
            topSize: 0.15
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
            l.fixed(chiaBox, selfBox, 0.0, 0.0, 0.7, 1.0)
            l.fixed(chibBox, selfBox, 0.7, 0.0, 0.3, 1.0)
            selfBox
        }
    }

    function layout(l) {
        selfBox = l.genBox :tmp, self
        chBox   = children.map {|x| x.layout l}
        l.fixed(chBox[0], selfBox, 0.0, 0.00, 1.0, 0.17)
        l.fixed(chBox[1], selfBox, 0.0, 0.17, 1.0, 0.50)
        l.fixed(chBox[2], selfBox, 0.0, 0.67, 1.0, 0.33)
        selfBox
    }
}
