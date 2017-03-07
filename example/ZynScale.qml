Widget {
    id: micro
    function class_name() { "part" }
    function layout(l, selfBox) {
        Draw::Layout::vfill(l, selfBox, children, [0.2,0.10,0.70])
    }
    Group {
        topSize: 0.2
        copyable: false
        label: "scale settings"
        ParModuleRow {
            ToggleButton { extern: micro.extern + "Penabled" }
            NumBox   {
                extern: micro.extern + "octavesize"
                label: "per/oct"
            }
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
                function layout(l, selfBox) {
                    Draw::Layout::hfill(l, selfBox, children, [0.3, 0.7], 0, 4)
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
                function layout(l, selfBox) {
                    Draw::Layout::hfill(l, selfBox, children, [0.3, 0.7], 0, 4)
                }
            }
            function class_name() { "partsub" }
            function layout(l, selfBox) {
                Draw::Layout::vpack(l, selfBox, children, 0, 1, 4)
            }
        }
        ParModuleRow {
            Knob { extern: micro.extern + "Pscaleshift" }
        }
        function draw(vg) {
            Draw::GradBox(vg, Rect.new(0,0,w,h))
        }
        function layout(l, selfBox)
        {
            children[0].fixed(l, selfBox, 0.0, 0, 0.9, 1)
            children[1].fixed(l, selfBox, 0.9, 0, 0.1, 1)
            selfBox
        }
    }
    ZynTuning {}
}
