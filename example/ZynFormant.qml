Widget {
    id: fbase
    extern: "/part0/kit0/adpars/GlobalPar/GlobalFilter/"
    VisFormant {
        id: vis
    }
    Widget {
        Widget {
            id: total
            Text    { label:  "formants" }
            NumEntry { extern: fbase.extern + "Pnumformants";  }
            HSlider { extern: fbase.extern + "Pformantslowness"; }
            HSlider { extern: fbase.extern + "Pvowelclearness"; }
            //space
            HSlider { extern: fbase.extern + "Pcenterfreq" }
            HSlider { extern: fbase.extern + "Poctavesfreq" }
            function layout(l) {
                Draw::Layout::vpack(l, self_box(l), chBoxes(l), 0.1, 0.8, 12)
            }
            function onSetup(old=nil) {
                lm = lambda { vis.refresh() }
                children.each do |ch|
                    ch.whenValue = lm if ch.respond_to? :whenValue
                end
            }
            function draw(vg) {
                Draw::GradBox(vg, Rect.new(0,0,w,h))
            }
        }
        Widget {
            Group {
                id:    vgrp
                label: "vowel"
                topSize: 0.2
                extern: fbase.extern + "Pvowels0/Pformants0/"
                function update_pos()
                {
                    vgrp.extern = fbase.extern + "Pvowels#{vow_num.value}/Pformants#{for_num.value}/"
                    db.update_values

                    puts vgrp.extern
                    children[0].children.each do |ch|
                        puts ch.extern
                    end
                }
                Widget {
                    NumEntry {
                        id: vow_num
                        label: "v. num"
                        whenValue: lambda {vgrp.update_pos}
                    }
                    HSlider {
                        extern: vgrp.extern + "freq";
                        label: "freq"
                        whenValue: lambda { vis.refresh() }
                    }
                    NumEntry {
                        id: for_num;
                        label: "formant"
                        whenValue: lambda {vgrp.update_pos}
                    }
                    HSlider {
                        extern: vgrp.extern + "q";
                        label: "q"
                        whenValue: lambda { vis.refresh() }
                    }
                    Widget {}
                    Widget {}
                    Widget {}
                    HSlider {
                        extern: vgrp.extern + "amp";
                        label: "amp"
                        whenValue: lambda { vis.refresh() }
                    }
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
                    HSlider {
                        extern: fbase.extern + "Psequencesize";
                        label: "seqsize"
                        whenValue: lambda { vis.refresh() }
                    }
                    HSlider {
                        extern: fbase.extern + "Psequencestretch";
                        label: "strch"
                        whenValue: lambda { vis.refresh() }
                    }
                    HSlider { label: "s.pos" }
                    Widget {}
                    HSlider { label: "vowel"}
                    Button {  extern: fbase.extern + "Psequencereversed"; label: "neg. input"; layoutOpts: [:no_constraint]}

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
