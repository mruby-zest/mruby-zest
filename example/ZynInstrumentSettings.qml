Group {
    label: "instrument settings"
    copyable: false
    id: insset
    Widget {
        ParModuleRow {
            whitespace: 2
            Knob { extern: insset.extern + "Pvolume"}
            Knob { extern: insset.extern + "Ppanning"}
            Knob {
                id: minkey
                extern: insset.extern + "Pminkey"
            }
            Knob {
                id: maxkey
                extern: insset.extern + "Pmaxkey"
            }
        }
        ParModuleRow {
            whitespace: 3
            outer: :none
            layoutOpts: []
            Knob {extern: insset.extern + "Pvelsns"}
            Knob {extern: insset.extern + "Pveloffs"}
            Knob {extern: insset.extern + "Pkeyshift"}
            ZynKitKeyButton {
                layoutOpts: [:aspect]
                extern: insset.extern
                whenValue: lambda {
                    minkey.refresh
                    maxkey.refresh
                }
            }
        }
        ParModuleRow {
            lsize: 0.0
            Selector     {
                extern: insset.extern + "Prcvchn";
                label: "midi chan"
            }
            ToggleButton {
                extern: insset.extern + "ctl/portamento.portamento";
                label: "portamento"
            }
            Selector {
                extern: insset.extern + "polyType";
                label: "mode";
                layoutOpts: [:no_constraint, :long_mode]
            }
        }
        function layout(l, selfBox) {
            Draw::Layout::vfill(l, selfBox, children, [0.40, 0.40,0.2],0,2)
        }
    }
}
