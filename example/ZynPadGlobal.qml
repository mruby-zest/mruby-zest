Widget {
    id: padglobal

    property Object valueRef: nil
    property Symbol filtertype: nil


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

        function set_lfo(ext, tab)
        {
            e_  = {:filter => "FilterLfo/",
                   :amp    => "AmpLfo/",
                   :freq   => "FreqLfo/"}[tab]
            return if e_.nil?
            self.extern  = ext + e_
            self.content = Qml::LfoVis
            self.children[0].children[0].extern = amp_lfo.extern+"out"
        }

        function set_env(ext, tab)
        {
            e_  = {:filter => "FilterEnvelope/",
                   :amp    => "AmpEnvelope/",
                   :freq   => "FreqEnvelope/"}[tab]
            return if e_.nil?
            self.extern  = ext + e_
            self.content = Qml::ZynEnvEdit
            #self.children[0].children[0].extern = amp_env.extern+"out"
            amp_env.children[0].whenModified = lambda {
                elm = row1.children[0]
                elm.refresh if elm.respond_to? :refresh
            }
        }

        function set_filter(ext)
        {
            puts "padglobal.filtertype = #{padglobal.filtertype}"
            self.extern = ext + "GlobalFilter/"
            if(padglobal.filtertype == :formant)
                self.content = Qml::ZynFormant
            else
                self.content = Qml::VisFilter
                self.children[0].extern = ext + "GlobalFilter/response"
            end
            amp_gen.children[0].whenModified = lambda {
                elm = row1.children[0]
                elm.refresh if elm.respond_to? :refresh
            }
        }

        function setDataVis(type, tab)
        {
            ext = "/part0/kit0/padpars/"
            if(type == :lfo)
                set_lfo(ext, tab)
            elsif(type == :env)
                set_env(ext, tab)
            elsif(type == :filter)
                set_filter(ext)
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
            content: Qml::ZynPadAmp
            whenSwapped: lambda {
                if(amp_gen.content == Qml::ZynAnalogFilter)
                    ch = amp_gen.children[0]
                    ch.whenClick = lambda {row1.setDataVis(:filter, :filter)}
                end
            }
        }
        Swappable {
            id: amp_env
            extern: "/part0/kit0/padpars/AmpEnvelope/"
            content: Qml::ZynAmpEnv
        }
        ZynLFO {
            extern: "/part0/kit0/padpars/AmpLfo/"
            whenClick: lambda {row1.setDataVis(:lfo, nil)}
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

        function set_amp(base)
        {
            amp_gen.extern  = base
            amp_env.extern  = base + "AmpEnvelope/"
            amp_lfo.extern  = base + "AmpLfo/"
            amp_gen.content = Qml::ZynPadAmp
            amp_env.content = Qml::ZynAmpEnv
            amp_env.children[0].whenClick = lambda {row1.setDataVis(:env, :amp)}
            amp_lfo.whenClick = lambda {row1.setDataVis(:lfo, :amp)}
        }

        function set_freq(base)
        {
            puts "amp_env.base = #{base}"
            amp_gen.extern  = base
            amp_env.extern  = base + "FreqEnvelope/"
            amp_lfo.extern  = base + "FreqLfo/"
            amp_gen.content = Qml::ZynPadFreq
            amp_env.content = Qml::ZynFreqEnv
            amp_env.children[0].whenClick = lambda {row1.setDataVis(:env, :freq)}
            amp_lfo.whenClick = lambda {row1.setDataVis(:lfo, :freq)}
        }

        function set_filter(base)
        {
            puts "set_filter..."
            amp_gen.extern  = base + "GlobalFilter/"
            puts amp_gen.extern
            amp_env.extern  = base + "FilterEnvelope/"
            amp_lfo.extern  = base + "FilterLfo/"
            amp_gen.content = Qml::ZynAnalogFilter
            amp_env.content = Qml::ZynFilterEnv
            amp_env.children[0].whenClick = lambda {row1.setDataVis(:env, :filter)}
            amp_lfo.whenClick = lambda {row1.setDataVis(:lfo, :filter)}
        }

        function setTab(id)
        {
            puts "set tab in padsynth"
            (0..2).each do |ch_id|
                children[ch_id].value = (ch_id == id)
                children[ch_id].damage_self
            end
            base = "/part0/kit0/padpars/"
            if(id == 0)
                set_amp base
            elsif(id == 1)
                set_freq base
            elsif(id == 2)
                set_filter base
            end
            db.update_values
        }

        TabButton { label: "amplitude"; whenClick: lambda {footer.setTab(0)}; highlight_pos: :top; value: true}
        TabButton { label: "frequency"; whenClick: lambda {footer.setTab(1)}; highlight_pos: :top}
        TabButton { label: "filter";    whenClick: lambda {footer.setTab(2)}; highlight_pos: :top}
    }

    function onSetup(old=nil)
    {
        if(padglobal.valueRef.nil?)
            path = padglobal.extern + "GlobalFilter/Pcategory"
            padglobal.valueRef = OSC::RemoteParam.new($remote, path)
            padglobal.valueRef.mode = :full
            padglobal.valueRef.callback = lambda {|x|
                padglobal.filtertype = [:analog, :formant, :statevar][x]
            }
        end
        footer.setTab(0)
    }
}
