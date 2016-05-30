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

        l.contains(selfBox, row1Box)
        l.contains(selfBox, row2Box)

        #Global Optimizatoin
        l.topOf(row1Box, row2Box)
        l.sheq([row1Box.h, row2Box.h], [1, -1.2], 0)

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
                self.children[0].children[0].extern = "/part0/kit0/adpars/GlobalPar/AmpLfo/out"
            elsif(type == :env)
                self.content = Qml::Envelope
                self.children[0].extern = "/part0/kit0/adpars/GlobalPar/AmpEnvelope/out"
                self.children[0].children[0].extern = "/part0/kit0/adpars/GlobalPar/AmpEnvelope/out"
            end
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


        ZynAmpGeneral {
            id: amp_gen
        }
        ZynAmpEnv {
            whenClick: lambda {row1.setDataVis(:env)}
            id: amp_env
        }
        ZynLFO {
            whenClick: lambda {row1.setDataVis(:lfo)}
            id: amp_lfo
        }
    }
}
