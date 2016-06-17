Widget {
    id: base
    extern: "/part0/kit0/adpars/VoicePar0/"
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
            ParModuleRow {
                Knob { extern: base.extern + "PFMVolume" }
                Knob { extern: base.extern + "PFMVelocityScaleFunction" }
                Knob { extern: base.extern + "PFMVolumeDamp" }
            }
        }
        ZynModAmpEnv {
            label: "amp env"
            topSize: 0.2
            extern: base.extern + "FMAmpEnvelope/"
        }
        ZynModFreqGeneral {
            label: "mod freq"
            topSize: 0.2
            extern: base.extern
        }
        ZynModAmpEnv {
            label: "freq env"
            topSize: 0.2
            extern: base.extern + "FMFreqEnvelope/"
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
            ParModuleRow {
                Selector {
                    layoutOpts: [:no_constraint]
                    extern: base.extern + "Pextoscil"
                }
            }
            ParModuleRow {
                Knob {extern: base.extern + "Poscilphase"}
            }
            ParModuleRow {
                Button { label: "sound"}
                Button { label: "noise"}
            }
        }
        WaveView { }
        Group {
            label: "unison"
            ParModuleRow {
                Selector {
                    extern: base.extern + "Unison_size"
                }
                Knob {
                    extern: base.extern + "Unison_stereo_spread"
                }
            }
            ParModuleRow {
                Knob {
                    extern: base.extern + "Unison_frequency_spread"
                }
                Knob {
                    extern: base.extern + "Unison_vibratto"
                }
            }
            ParModuleRow {
                Selector {
                    extern: base.extern + "Unison_invert_phase"
                }
                Knob {
                    extern: base.extern + "Unison_vibratto_speed"
                }
            }
        }
        WaveView { }
        Group {
            label: "mod osc"
            ParModuleRow {
                Selector {
                    extern: base.extern + "PextFMoscil"
                    layoutOpts: [:no_constraint]
                }
            }
            ParModuleRow{
                Knob {
                    extern: base.extern+"PFMoscilphase"
                }
            }
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
