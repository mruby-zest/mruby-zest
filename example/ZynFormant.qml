Widget {
    VisFormant {
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
            function layout(l) {
                Draw::Layout::vpack(l, self_box(l), chBoxes(l), 0.1, 0.8, 12)
            }
            function draw(vg) {
                Draw::GradBox(vg, Rect.new(0,0,w,h))
            }
        }
        Widget {
            Group {
                label: "vowel"
                topSize: 0.2
                Widget {
                    HSlider { label: "v. num" }
                    HSlider { label: "freq" }
                    HSlider { label: "formant" }
                    HSlider { label: "q" }
                    Widget {}
                    Widget {}
                    Widget {}
                    HSlider { label: "amp" }
                    function layout(l) {
                        Draw::Layout::grid(l, self_box(l), chBoxes(l), 4, 2, 2, 2)
                    }
                    //grid(l, selfBox, children, rows, cols, padw=0, padh=0)
                }
            }
            Group {
                label: "sequence"
                topSize: 0.2
                copyable: false
                Widget {
                    HSlider { label: "seqsize" }
                    HSlider { label: "strch" }
                    HSlider { label: "s.pos" }
                    Widget {}
                    HSlider { label: "vowel"}
                    Button { label: "neg. input"; layoutOpts: [:no_constraint]}

                    function layout(l) {
                        Draw::Layout::grid(l, self_box(l), chBoxes(l), 3, 2, 2, 4)
                    }
                }
            }
            function layout(l) {
                Draw::Layout::vpack(l, self_box(l), chBoxes(l))
            }
        }
        function layout(l) {
            Draw::Layout::hfill(l, self_box(l), chBoxes(l), [0.3, 0.7], 0, 2)
        }
    }
    function layout(l) {
        Draw::Layout::hfill(l, self_box(l), chBoxes(l), [0.7, 0.3], 0, 2)
    }


}
