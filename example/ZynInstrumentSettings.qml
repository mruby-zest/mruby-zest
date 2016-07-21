Group {
    label: "instrument settings"
    copyable: false
    id: insset
    Widget {
        ParModuleRow {
            whitespace: 2
            Knob { extern: insset.extern + "Pvolume"}
            Knob { extern: insset.extern + "Ppanning"}
            Knob { extern: insset.extern + "Pminkey" }
            Knob { extern: insset.extern + "Pmaxkey" }
        }
        ParModuleRow {
            whitespace: 3
            outer: :none
            Knob {extern: insset.extern + "Pvelsns"}
            Knob {extern: insset.extern + "Pveloffs"}
            Knob {extern: insset.extern + "Pkeyshift"}
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
            Selector     { extern: insset.extern + "Prcvchn"; label: "midi chan"}
            ToggleButton { extern: insset.extern + "ctl/portamento.portamento"; layoutOpts: [:no_constraint]; label: "portamento"}
            Selector     { extern: insset.extern + "polyType"; label: "mode"; layoutOpts: [:no_constraint]  }
        }
        function layout(l) {
            Draw::Layout::vfill(l, self_box(l), chBoxes(l), [0.40, 0.40,0.2],0,2)
        }
    }
}
