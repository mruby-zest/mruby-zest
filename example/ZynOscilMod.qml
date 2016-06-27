Widget {
    id: base
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
                    content: Qml::ZynAmpGeneral
                }
                Swappable {
                    id: env
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
            extern: base.extern
        }

        function layout(l)
        {
            selfBox = l.genBox :modbox, self
            Draw::Layout::hfill(l, selfBox, chBoxes(l), [0.6,0.4])
        }
    }
    Widget {
        id: footer

        TabButton { label: "amplitude"; whenClick: lambda {footer.setTab(0)}; highlight_pos: :top; value: true}
        TabButton { label: "frequency"; whenClick: lambda {footer.setTab(1)}; highlight_pos: :top}

        function layout(l) {
            Draw::Layout::tabpack(l, self)
        }

        function setTab(id)
        {
            (0..1).each do |ch_id|
                children[ch_id].value = (ch_id == id)
                self.root.damage_item children[ch_id]
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
