Widget {
    Widget {
        id: vis
    }
    Widget {
        Widget {
            id: total
            HSlider { label: "num f." }
            HSlider { label: "fr.sl." }
            HSlider { label: "vw.cl" }
            //space
            HSlider { label: "c.f." }
            HSlider { label: "oct." }
        }
        Widget {
            Group {
                label: "vowel"
                Widget {
                    HSlider { label: "v. num" }
                    HSlider { label: "freq" }
                    HSlider { label: "formant" }
                    HSlider { label: "q" }
                    Widget {}
                    Widget {}
                    Widget {}
                    HSlider { label: "amp" }
                }
            }
            Group {
                label: "sequence"
                Widget {
                    HSlider { label: "seqsize" }
                    HSlider { label: "strch" }
                    HSlider { label: "s.pos" }
                    Widget {}
                    HSlider { label: "vowel"}
                    Button { label: "neg. input"; layoutOpts: [:no_constraint]}

                }
            }
        }
    }
}
