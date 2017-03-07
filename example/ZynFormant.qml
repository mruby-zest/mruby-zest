Widget {
    id: fbase
    VisFormant {
        id: vis
        extern: fbase.extern
    }
    Widget {
        Widget {
            id: total
            Text    { label:  "formants" }
            NumEntry {
                format: "PKs "
                extern: fbase.extern + "Pnumformants";
            }
            HSlider { extern: fbase.extern + "Pformantslowness"; }
            HSlider { extern: fbase.extern + "Pvowelclearness"; }
            //space
            HSlider { extern: fbase.extern + "Pcenterfreq" }
            HSlider { extern: fbase.extern + "Poctavesfreq" }
            function layout(l, selfBox) {
                Draw::Layout::vpack(l, selfBox, children, 0.1, 0.8, 12)
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
                    vis.vowel_num = vow_num.value-1
                    vis.change()
                    rt = fbase.extern + "Pvowels#{vow_num.value-1}/Pformants#{for_num.value-1}/"
                    slide_freq.extern = rt + "freq"
                    slide_q.extern    = rt + "q"
                    slide_amp.extern  = rt + "amp"
                    db.update_values
                }
                Widget {
                    NumEntry {
                        id: vow_num
                        label: "v. num"
                        format: "VW "
                        tooltip: "vowel number - each formant filter is composed of one or more vowels"
                        minimum: 1
                        maximum: 6
                        value: 1
                        whenValue: lambda {vgrp.update_pos}
                    }
                    HSlider {
                        id: slide_freq
                        extern: vgrp.extern + "freq";
                        label: "freq"
                        whenValue: lambda { vis.refresh() }
                    }
                    NumEntry {
                        id: for_num;
                        label: "formant"
                        format: "PK "
                        tooltip: "formant peak - each formant vowel is composed of one or more peaks"
                        minimum: 1
                        maximum: 12
                        value: 1
                        whenValue: lambda {vgrp.update_pos}
                    }
                    HSlider {
                        id: slide_q
                        extern: vgrp.extern + "q";
                        label: "q"
                        whenValue: lambda { vis.refresh() }
                    }
                    Widget {}
                    Widget {}
                    Widget {}
                    HSlider {
                        id: slide_amp
                        extern: vgrp.extern + "amp";
                        label: "amp"
                        whenValue: lambda { vis.refresh() }
                    }
                    function layout(l, selfBox) {
                        Draw::Layout::grid(l, selfBox, children, 4, 2, 2, 2)
                    }
                    //grid(l, selfBox, children, rows, cols, padw=0, padh=0)
                }
            }
            Group {
                label: "sequence"
                topSize: 0.2
                copyable: false
                Widget {
                    NumEntry {
                        extern: fbase.extern + "Psequencesize";
                        format: "LEN "
                        label: "seqsize"
                        whenValue: lambda { vis.refresh() }
                    }
                    NumEntry {
                        id: pos_id
                        format: "POS "
                        value:  1
                        minimum: 1
                        maximum: 8
                        label: "s.pos"
                        whenValue: lambda {
                            pos_vowel.extern = 
                            fbase.extern + "vowel_seq#{pos_id.value-1}"
                        }
                    }
                    HSlider {
                        extern: fbase.extern + "Psequencestretch";
                        label: "strch"
                        whenValue: lambda { vis.refresh() }
                    }
                    Widget {}
                    NumEntry {
                        id: pos_vowel
                        format: "VW "
                        label: "vowel"
                        offset: 1
                        minimum: 1
                        maximum: 8
                        extern: fbase.extern + "vowel_seq0"
                    }
                    Button {
                        extern: fbase.extern + "Psequencereversed";
                        label: "neg. input";
                        layoutOpts: [:no_constraint]
                    }

                    function layout(l, selfBox) {
                        Draw::Layout::grid(l, selfBox, children, 3, 2, 2, 4)
                    }
                }
            }
            function layout(l, selfBox) {
                Draw::Layout::vpack(l, selfBox, children)
            }
        }
        function layout(l, selfBox) {
            Draw::Layout::hfill(l, selfBox, children, [0.3, 0.7], 0, 2)
        }
    }
    function layout(l, selfBox) {
        Draw::Layout::hfill(l, selfBox, children, [0.7, 0.3], 0, 2)
    }


}
