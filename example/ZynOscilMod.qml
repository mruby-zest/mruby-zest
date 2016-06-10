Widget {
    ColorBox {
        ColorBox {
            bg: Theme::GeneralBackground
            Selector { layoutOpts: [:no_constraint]}
            Button { layoutOpts: [:no_constraint]}
            function layout(l)
            {
                selfBox = l.genBox :extmod, self
                Draw::Layout::vpack(l, selfBox, chBoxes(l))
            }
        }
        Group {
            label: "mod amp"
            topSize: 0.2
        }
        Group {
            label: "amp env"
            topSize: 0.2
        }
        Group {
            label: "mod freq"
            topSize: 0.2
        }
        Group {
            label: "freq env"
            topSize: 0.2
        }
        function layout(l)
        {
            selfBox = l.genBox :modboxbot, self
            Draw::Layout::hfill(l, selfBox, chBoxes(l),
            [0.1, 0.15, 0.25, 0.25, 0.25])
        }
    }
    Envelope {
    }
    ColorBox {
        Group {
            label: "vce osc"
            Selector { layoutOpts: [:no_constraint]}
            Knob {}
            ParModuleRow {
                Button { label: "sound"}
                Button { label: "noise"}
            }
        }
        WaveView { }
        Group {
            label: "unison"
            ParModuleRow {
                Selector {}
                Knob {}
            }
            ParModuleRow {
                Knob {}
                Knob {}
            }
            ParModuleRow {
                Selector {}
                Knob {}
            }
        }
        WaveView { }
        Group {
            label: "mod osc"
            Selector {layoutOpts: [:no_constraint]}
            Knob {}
        }
        function layout(l)
        {
            selfBox = l.genBox :modboxbot, self
            Draw::Layout::hfill(l, selfBox, chBoxes(l),
            [0.15, 0.275, 0.15, 0.275, 0.15])
        }
    }
    function layout(l)
    {
        selfBox = l.genBox :modbox, self
        Draw::Layout::vfill(l, selfBox, chBoxes(l), [0.2,0.4,0.4])
    }
}
