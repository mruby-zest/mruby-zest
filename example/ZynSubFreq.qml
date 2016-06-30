Widget {
    id: subfq
    extern: "/part0/kit0/subpars/"
    //visual
    Widget {}
    Widget {
        Group {
            label: "general"
            ParModuleRow {
                Knob {     extern: subfq.extern + "PDetune" }
                Knob {     extern: subfq.extern + "octave" }
                Selector { extern: subfq.extern + "PDetuneType" }
                //TODO relbw
                //eqt
                Button {   extern: subfq.extern + "Pfixedfreq" }
                Knob   {   extern: subfq.extern + "PfixedfreqET" }
                //TODO cdet

            }
        }
        ZynFreqEnv {extern: subfq.extern+"FreqEnvelope/"}
        function layout(l) {
            Draw::Layout::hpack(l, self_box(l), chBoxes(l))
        }
    }
    function layout(l) {
        Draw::Layout::vfill(l, self_box(l), chBoxes(l), [0.6, 0.4])
    }
}
