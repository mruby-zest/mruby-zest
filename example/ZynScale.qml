Widget {
    function class_name() { "part" }
    function layout(l) {
        Draw::Layout::vfill(l, self_box(l), chBoxes(l), [0.2,0.15,0.65])
    }
    Group {
        topSize: 0.2
        label: "scale settings"
        ParModuleRow {
            Button { label: "enable" }
            ColorBox { label: "per/oct" }
            Knob { label: "a.fq" }
            Knob { label: "a.note" }
            Knob { label: "center" }
        }
    }
    Widget {
        Widget {
            Widget {
                Text { label: "name:" }
                ColorBox {
                    bg: color("222222")
                }
                function layout(l) {
                    Draw::Layout::hfill(l, self_box(l), chBoxes(l), [0.3, 0.7], 0, 4)
                }
            }
            Widget {
                Text { label: "comment:" }
                ColorBox {
                    bg: color("222222")
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
            Knob { label: "shift" }
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
