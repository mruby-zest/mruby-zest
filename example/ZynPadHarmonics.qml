Widget {
    id: base
    extern: "/part0/kit0/padpars/"
    Widget {
        HarmonicView {
            id: nhr
            type:   :pad
            extern: base.extern
        }
        ZynPadOvertone {
            extern: base.extern
            whenValue: lambda { nhr.refresh }
        }
        function layout(l, selfBox) {
            children[0].fixed(l, selfBox, 0.0, 0.0, 0.6, 1.0)
            children[1].fixed(l, selfBox, 0.6, 0.0, 0.4, 1.0)
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
        function layout(l, selfBox) {
            children[0].fixed(l, selfBox, 0.0, 0.0, 0.7, 1.0)
            children[1].fixed(l, selfBox, 0.7, 0.0, 0.3, 1.0)
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
                lsize: 0.4
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
            Col{
                Selector {
                    extern: base.extern + "Pquality.samplesize"
                    layoutOpts: [:long_mode]
                }
                Text {label: "sample size"}
            }
        }
        function layout(l, selfBox) {
            children[0].fixed(l, selfBox, 0.0, 0.0, 0.7, 1.0)
            children[1].fixed(l, selfBox, 0.7, 0.0, 0.3, 1.0)
            selfBox
        }
    }

    function layout(l, selfBox) {
        children[0].fixed(l, selfBox, 0.0, 0.00, 1.0, 0.17)
        children[1].fixed(l, selfBox, 0.0, 0.17, 1.0, 0.50)
        children[2].fixed(l, selfBox, 0.0, 0.67, 1.0, 0.33)
        selfBox
    }
}
