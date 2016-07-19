Widget {
    id: micro
    function class_name() { "part" }
    function layout(l) {
        Draw::Layout::vfill(l, self_box(l), chBoxes(l), [0.2,0.10,0.70])
    }
    Group {
        topSize: 0.2
        copyable: false
        label: "scale settings"
        ParModuleRow {
            ToggleButton { extern: micro.extern + "Penabled" }
            ColorBox { extern: micro.extern + "osctavesize"; label: "per/oct" }
            Knob {
                extern: micro.extern + "PAfreq"
                type: "f"
            }
            Knob { extern: micro.extern + "PAnote" }
            Knob { extern: micro.extern + "Pinvertupdowncenter" }
        }
    }
    Widget {
        Widget {
            Widget {
                Text {
                    label: "name:"
                    height: 0.8
                }
                TextLine {
                    extern: micro.extern + "Pname"
                }
                function layout(l) {
                    Draw::Layout::hfill(l, self_box(l), chBoxes(l), [0.3, 0.7], 0, 4)
                }
            }
            Widget {
                Text {
                    label: "comment:"
                    height: 0.8
                }
                TextLine {
                    extern: micro.extern + "Pcomment"
                }
                function layout(l) {
                    Draw::Layout::hfill(l, self_box(l), chBoxes(l), [0.3, 0.7], 0, 4)
                }
            }
            function class_name() { "partsub" }
            function layout(l) {
                Draw::Layout::vpack(l, self_box(l), chBoxes(l), 0, 1, 4)
            }
        }
        ParModuleRow {
            Knob { extern: micro.extern + "Pscaleshift" }
        }
        function draw(vg) {
            Draw::GradBox(vg, Rect.new(0,0,w,h))
        }
        function layout(l)
        {
            selfBox = l.genBox :part, self
            l.fixed(children[0].layout(l), selfBox, 0.0, 0, 0.9, 1)
            l.fixed(children[1].layout(l), selfBox, 0.9, 0, 0.1, 1)
            selfBox
        }
    }
    ZynTuning {}
}
