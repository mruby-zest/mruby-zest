Widget {
    id: subfq
    extern: "/part0/kit0/subpars/"
    //visual
    ZynEnvEdit {
        extern: subfq.extern + "FreqEnvelope/"
    }
    Widget {
        Group {
            label: "general"
            ParModuleRow {
                Knob {     extern: subfq.extern + "PDetune" }
                Knob {     extern: subfq.extern + "octave" }
                Selector { extern: subfq.extern + "PDetuneType" }
                //TODO relbw
                //eqt
                ToggleButton {   extern: subfq.extern + "Pfixedfreq" }
                Knob   {   extern: subfq.extern + "PfixedfreqET" }
                //TODO cdet

            }
        }
        ZynFreqEnv {
            toggleable: subfq.extern + "PFreqEnvelopeEnabled"
            extern: subfq.extern+"FreqEnvelope/"
        }
        function layout(l) {
            Draw::Layout::hpack(l, self_box(l), chBoxes(l))
        }
    }
    function layout(l) {
        Draw::Layout::vfill(l, self_box(l), chBoxes(l), [0.6, 0.4])
    }
}
