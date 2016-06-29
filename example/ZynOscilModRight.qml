Widget {
    id: base
    Indent {
        ParModuleRow {
            Selector { layoutOpts: [:no_constraint]}
            Button { label: "external modulator"; }
        }
        function draw(vg) {
            Draw::GradBox(vg, Rect.new(0,0,w,h))
        }
    }
    Group {
        label: "unison"
        topSize: 0.2
        copyable: false
        ParModuleRow {
            NumEntry {
                extern: base.extern + "Unison_size"
            }
            Knob {
                extern: base.extern + "Unison_frequency_spread"
            }
            Knob {
                extern: base.extern + "Unison_stereo_spread"
            }
            Knob {
                extern: base.extern + "Unison_vibratto"
            }
            Knob {
                extern: base.extern + "Unison_vibratto_speed"
            }
            Selector {
                extern: base.extern + "Unison_invert_phase"
            }
        }
    }
    Widget {
        Widget {
            Group {
                label: "vce osc"
                topSize: 0.15
                copyable: false
                ParModuleRow {
                    Selector {
                        extern: base.extern + "Pextoscil"
                        options: ["normal", "voice 0", "voice 1"]
                    }
                    Knob {extern: base.extern + "Poscilphase"}
                }
                ParModuleRow {
                    Button { label: "sound"}
                    Button { label: "noise"}
                }
            }
            WaveView { grid: false}
            function layout(l) {
                selfBox = l.genBox :modbox, self
                Draw::Layout::vfill(l, selfBox, chBoxes(l),
                    [0.4,0.6])
            }
        }
        Widget {
            Group {
                label: "mod osc"
                topSize: 0.15
                copyable: false
                ParModuleRow {
                    Selector {
                        extern: base.extern + "PextFMoscil"
                        //layoutOpts: [:no_constraint]
                    }
                    Knob {
                        extern: base.extern+"PFMoscilphase"
                    }
                }
            }
            WaveView {grid: false }
            function layout(l) {
                selfBox = l.genBox :modbox, self
                Draw::Layout::vfill(l, selfBox, chBoxes(l),
                    [0.4,0.6])
            }
        }
        function layout(l) {
            selfBox = l.genBox :modbox, self
            Draw::Layout::hpack(l, selfBox, chBoxes(l))
        }
    }
    function layout(l)
    {
        selfBox = l.genBox :modbox, self
        Draw::Layout::vfill(l, selfBox, chBoxes(l),
            [0.15,0.2,0.65])
    }
}
