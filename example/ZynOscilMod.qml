Widget {
    id: basemod
    extern: "/part0/kit0/adpars/VoicePar0/"
    Widget {
        Widget {
            Widget {
                Swappable {
                    id: vis
                    content: Qml::Envelope
                }
            }
            Widget {
                Swappable {
                    id: gen
                    extern:  basemod.extern
                    content: Qml::ZynAmpMod
                }
                Swappable {
                    id: env
                    extern: basemod.extern+"FMAmpEnvelope/"
                    content: Qml::ZynAmpEnv
                }
                function layout(l) {
                    selfBox = l.genBox :modbox, self
                    Draw::Layout::hpack(l, selfBox, chBoxes(l))
                }
            }
            function layout(l) {
                selfBox = l.genBox :modbox, self
                Draw::Layout::vfill(l, selfBox, chBoxes(l), [0.6,0.4])
            }
        }
        ZynOscilModRight {
            extern: basemod.extern
        }

        function layout(l)
        {
            selfBox = l.genBox :modbox, self
            Draw::Layout::hfill(l, selfBox, chBoxes(l), [0.6,0.4])
        }
    }
    TabGroup {
        id: footer

        TabButton {
            label: "amplitude";
            highlight_pos: :top;
            value: true
        }
        TabButton {
            label: "frequency";
            highlight_pos: :top
        }

        function set_tab(wid)
        {
            id = get_tab wid
            if(id == 0)
                gen.extern  = basemod.extern
                env.extern  = basemod.extern + "FMAmpEnvelope/"
                gen.content = Qml::ZynAmpMod
                env.content = Qml::ZynAmpEnv
            elsif(id == 1)
                gen.extern  = basemod.extern
                env.extern  = basemod.extern + "FMFreqEnvelope/"
                gen.content = Qml::ZynFreqMod
                env.content = Qml::ZynAmpEnv
            end
            db.update_values
        }
    }

    function layout(l)
    {
        selfBox = l.genBox :modbox, self
        Draw::Layout::vfill(l, selfBox, chBoxes(l),
        [0.95,0.05])
    }
}
