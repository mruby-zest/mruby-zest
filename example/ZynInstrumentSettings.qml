Group {
    label: "instrument settings"
    copyable: false
    Widget {
        ParModuleRow {
            whitespace: 2
            Knob {label: "vol"}
            Knob {label: "pan"}
            Knob     { label: "min" }
            Knob     { label: "max"}
        }
        ParModuleRow {
            whitespace: 3
            outer: :none
            Knob {label: "sense"}
            Knob {label: "offset"}
            Knob {label: "key shift"}
            Widget {
                Button   { label: "m"; layoutOpts: [:no_constraint] }
                Button   { label: "r"; layoutOpts: [:no_constraint] }
                Button   { label: "m"; layoutOpts: [:no_constraint] }
                function layout(l) {
                    sb = self_box(l)
                    l.aspect(sb, 1, 3)
                    Draw::Layout::hpack(l, sb, chBoxes(l))
                }

            }
        }
        ParModuleRow {
            lsize: 0.4
            Selector { label: "midi chan"}
            Button   { layoutOpts: [:no_constraint]; label: "portamento"}
            Selector { label: "mode"; layoutOpts: [:no_constraint]  }
        }
        function layout(l) {
            Draw::Layout::vfill(l, self_box(l), chBoxes(l), [0.35, 0.35,0.3],0,2)
        }
    }
}
