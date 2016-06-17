Widget {

    function draw(vg)
    {
        bg_color      = color("424B56")
        vg.path do |v|
            v.rect(0, 0, self.w, self.h)
            v.fill_color(bg_color)
            v.fill
        end
    }

    function layout(l)
    {
        #puts "Center layout"
        selfBox = l.genBox :zynAddGlobal, self
        row1Box  = row1.layout(l)
        row2Box  = row2.layout(l)
        footBox  = footer.layout(l)

        l.contains(selfBox, row1Box)
        l.contains(selfBox, row2Box)
        l.contains(selfBox, footBox)

        #Global Optimizatoin
        l.topOf(row1Box, row2Box)
        l.topOf(row2Box, footBox)
        l.sheq([row1Box.h, row2Box.h], [1, -1.2], 0)
        l.sheq([footBox.h, selfBox.h], [1, -0.05], 0)

        selfBox
    }

    Swappable {
        id: row1
        content: Qml::LfoVis

        function setDataVis(type)
        {
            if(type == :lfo)
                self.content = Qml::LfoVis
                self.children[0].extern = "/part0/kit0/adpars/GlobalPar/AmpLfo/out"
                self.children[0].children[0].extern = amp_lfo.extern+"out"
            elsif(type == :env)
                self.content = Qml::Envelope
                self.children[0].extern = "/part0/kit0/adpars/GlobalPar/AmpEnvelope/"
                self.children[0].children[0].extern = amp_env.extern+"out"
                amp_env.whenModified = lambda {
                    row1.children[0].refresh
                }
            elsif(type == :filter)
                self.content = Qml::VisFilter
                self.children[0].extern = "/part0/kit0/adpars/GlobalPar/GlobalFilter/response"
                amp_gen.children[0].whenModified = lambda {
                    row1.children[0].refresh
                }
            end
            db.update_values
        }
    }

    Widget {
        id: row2
        function layout(l)
        {
            selfBox  = l.genBox :zynCenterRow2, self
            gen      = amp_gen.layout(l)
            env      = amp_env.layout(l)
            lfo      = amp_lfo.layout(l)
            l.contains(selfBox, gen)
            l.contains(selfBox, env)
            l.contains(selfBox, lfo)
            l.rightOf(gen, env)
            l.rightOf(env, lfo)

            #Making things look nice
            l.sheq([gen.w, selfBox.w], [1, -1/3.0],  0)
            l.sheq([env.w, selfBox.w], [1, -1/3.0],  0)

            selfBox
        }


        Swappable {
            id: amp_gen
            content: Qml::ZynAmpGeneral
            whenSwapped: lambda {
                puts "whenSwapped callback"
                if(amp_gen.content == Qml::ZynAnalogFilter)
                    ch = amp_gen.children[0]
                    ch.whenClick = lambda {row1.setDataVis(:filter)}
                end
            }
        }
        ZynAmpEnv {
            extern: "/part0/kit0/adpars/GlobalPar/AmpEnvelope/"
            whenClick: lambda {row1.setDataVis(:env)}
            id: amp_env
        }
        ZynLFO {
            extern: "/part0/kit0/adpars/GlobalPar/FreqLfo/"
            whenClick: lambda {row1.setDataVis(:lfo)}
            id: amp_lfo
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
            puts "set tab"
            (0..2).each do |ch_id|
                children[ch_id].value = (ch_id == id)
                self.root.damage_item children[ch_id]
            end
            base = "/part0/kit0/adpars/GlobalPar/"
            if(id == 0)
                amp_gen.content = Qml::ZynAmpGeneral
                amp_env.extern  = base + "AmpEnvelope/"
                amp_lfo.extern  = base + "AmpLfo/"
            elsif(id == 1)
                amp_gen.content = Qml::ZynFreqGeneral
                amp_env.extern  = base + "FreqEnvelope/"
                amp_lfo.extern  = base + "FreqLfo/"
            elsif(id == 2)
                amp_gen.content = Qml::ZynAnalogFilter
                amp_env.extern  = base + "FilterEnvelope/"
                amp_lfo.extern  = base + "FilterLfo/"
            end
            db.update_values
        }

        TabButton { label: "amplitude"; whenClick: lambda {footer.setTab(0)}; highlight_pos: :top; value: true}
        TabButton { label: "frequency"; whenClick: lambda {footer.setTab(1)}; highlight_pos: :top}
        TabButton { label: "filter";    whenClick: lambda {footer.setTab(2)}; highlight_pos: :top}
    }
}
