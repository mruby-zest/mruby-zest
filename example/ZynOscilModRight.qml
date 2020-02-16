Widget {
    id: base
    Indent {
        pad: 10
        ParModuleRow {
            Selector {
                extern: base.extern + "PFMEnabled";
                layoutOpts: [:no_constraint]
            }
            Selector {
                id: extmod;
                label: "external modulator";
            }
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
				minimum: 1
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
                    layoutOpts: []
                    lsize: 0.4
                    Selector {
                        id: ext
                        whenValue: lambda {
                            off  = ext.opt_vals[ext.selected]
                            off  = root.get_view_pos(:voice) if off == -1
                            off  = root.get_view_pos(:voice) if off.nil?
                            ext1 = "/VoicePar#{off}/OscilSmp/waveform"
                            ext2 = "/VoicePar#{off}/Type"
                            osc_wave.noise  = path_simp(base.extern+"../") + ext2
                            osc_wave.extern = path_simp(base.extern+"../") + ext1
                            osc_wave.damage_self
                        }
                        extern: base.extern + "Pextoscil"
                    }
                    Knob {
                        id: phase_osc
                        extern: base.extern + "Poscilphase"
                        whenValue: lambda {osc_wave.phase = phase_osc.value}
                    }
                }
                ParModuleRow {
                    lsize: 0.4
                    Selector {
                        extern: base.extern + "Type"
                    }
                }
            }
            WaveView {
                id: osc_wave
                draw_borders: true
                pad: 0.0225
                noise:  base.extern + "Type"
                extern: base.extern + "OscilSmp/waveform"
                grid: false
            }
            function layout(l, selfBox) {
                Draw::Layout::vfill(l, selfBox, children,
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
                        id: extfm
                        whenValue: lambda {
                            off = extfm.opt_vals[extfm.selected]
                            off = root.get_view_pos(:voice) if off == -1
                            off = root.get_view_pos(:voice) if off.nil?
                            ext = "/VoicePar#{off}/FMSmp/waveform"
                            mod_wave.extern = path_simp(base.extern+"../") + ext
                            mod_wave.damage_self
                        }
                        extern: base.extern + "PextFMoscil"
                    }
                    Knob {
                        id: phase_mod
                        extern: base.extern+"PFMoscilphase"
                        whenValue: lambda {
                            mod_wave.phase = phase_mod.value
                        }
                    }
                }
                Widget {}
            }
            WaveView {
                id: mod_wave
                grid: false
                pad: 0.0225
                draw_borders: true
                extern: base.extern + "FMSmp/waveform"
            }
            function layout(l, selfBox) {
                Draw::Layout::vfill(l, selfBox, children,
                    [0.4,0.6])
            }
        }
        function layout(l, selfBox) {
            Draw::Layout::hpack(l, selfBox, children)
        }
    }
    function layout(l, selfBox)
    {
        Draw::Layout::vfill(l, selfBox, children,
            [0.15,0.2,0.65])
    }

    function onSetup(old=nil)
    {
        vce     = root.get_view_pos(:voice)
        mapper  = [-1]
        names   = ["Normal"]
        names2  = ["Normal"]
        (0...vce).each do |i|
            mapper << i
            names  << "Oscil #{i+1}"
            names2 << "Mod   #{i+1}"
        end

        extfm.opt_vals = mapper
        extfm.options  = names
        extfm.extern   = base.extern + "PextFMoscil"
        ext.opt_vals   = mapper
        ext.options    = names
        ext.extern     = base.extern + "Pextoscil"
        extmod.opt_vals = mapper
        extmod.options  = names2
        extmod.extern   = base.extern + "PFMVoice"

    }
}
