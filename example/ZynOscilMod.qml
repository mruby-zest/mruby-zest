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

        function layout(l)
        {
            selfBox = l.genBox :zynCenterHeader, footer
            prev = nil

            total   = 0
            weights = []
            footer.children.each do |ch|
                scale = 100
                $vg.font_size scale
                weight   = $vg.text_bounds(0, 0, ch.label.upcase)
                weights << weight
                total   += weight
            end

            footer.children.each_with_index do |ch, idx|
                box = ch.layout(l)
                l.contains(selfBox,box)

                l.sh([box.w, selfBox.w], [1, -(1-1e-4)*weights[idx]/total], 0)

                #add in the aspect constraint
                l.aspect(box, 100, weights[idx])

                if(prev)
                    l.rightOf(prev, box)
                end
                prev = box
            end
            selfBox
        }

        function setTab(id)
        {
            (0..1).each do |ch_id|
                children[ch_id].value = (ch_id == id)
                self.root.damage_item children[ch_id]
            end
            db.update_values
        }

        TabButton { label: "amplitude"; whenClick: lambda {footer.setTab(0)}; highlight_pos: :top; value: true}
        TabButton { label: "frequency"; whenClick: lambda {footer.setTab(1)}; highlight_pos: :top}
    }

    function layout(l)
    {
        selfBox = l.genBox :modbox, self
        Draw::Layout::vfill(l, selfBox, chBoxes(l),
        [0.95,0.05])
    }
}
