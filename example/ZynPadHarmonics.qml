Widget {
    id: base
    extern: "/part0/kit0/padpars/"
    Widget {
        HarmonicView {
        }
        ZynPadOvertone {
            extern: base.extern
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
        VisHarmonic {
            id: visharm
            extern: base.extern + "harmonic_profile"
        }
        Group {
            label: "harmonic profile"
            topSize: 0.09
            copyable: false

            ZynPadProfile {
                extern: base.extern
                whenValue: lambda { visharm.refresh }
            }
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
            extern: base.extern + "oscilgen/waveform"
        }
        Group {
            topSize: 0.15
            label: "harmonic content"
            copyable: false
            ParModuleRow {
                Selector {
                    extern: base.extern + "Pquality.basenote"
                }
                Selector {
                    extern: base.extern + "Pquality.smpoct"
                }
                NumEntry {
                    extern: base.extern + "Pquality.oct"
                    label: "octaves"
                }
            }
            Text {label: "sample size"}
            Selector {
                extern: base.extern + "Pquality.samplesize"
            }
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
        chBox   = chBoxes(l)
        l.fixed(chBox[0], selfBox, 0.0, 0.00, 1.0, 0.17)
        l.fixed(chBox[1], selfBox, 0.0, 0.17, 1.0, 0.50)
        l.fixed(chBox[2], selfBox, 0.0, 0.67, 1.0, 0.33)
        selfBox
    }
}
