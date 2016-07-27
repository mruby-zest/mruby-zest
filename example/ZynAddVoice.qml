Widget {
    id: addbase
    extern: "/part0/kit0/adpars/VoicePar0/"

    function layout(l)
    {
        #puts "Center layout"
        selfBox = l.genBox :zynAddGlobal, self
        row1Box  = row1.layout(l)
        row2Box  = row2.layout(l)
        footBox  = footer.layout(l)

        [row1Box, row2Box, footBox].each do |box|
            l.contains(selfBox, box)
        end

        #Global Optimization
        l.topOf(row1Box, row2Box)
        l.topOf(row2Box, footBox)
        l.sheq([row1Box.h, row2Box.h], [1, -1.2], 0)
        l.sheq([footBox.h, selfBox.h], [1, -0.05], 0)

        selfBox
    }

    Swappable {
        id: row1

        function setDataVis(type, tab) {
            root.set_view_pos(:vis, type)
            root.change_view
        }
    }

    Widget {
        id: row2
        function layout(l)
        {
            selfBox  = l.genBox :zynCenterRow2, self
            genBox   = gen.layout(l)
            envBox   = env.layout(l)
            lfoBox   = lfo.layout(l)
            l.contains(selfBox, genBox)
            l.contains(selfBox, envBox)
            l.contains(selfBox, lfoBox)
            l.rightOf(genBox, envBox)
            l.rightOf(envBox, lfoBox)

            #Making things look nice
            l.sheq([genBox.w, selfBox.w], [1, -1/3.0],  0)
            l.sheq([envBox.w, selfBox.w], [1, -1/3.0],  0)

            selfBox
        }


        Swappable {
            id: gen
        }
        Swappable {
            id: env
        }
        Swappable {
            id: lfo
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
            mapping = {0 => :amplitude,
                       1 => :frequency,
                       2 => :filter}
            root.set_view_pos(:subsubview, mapping[id])
            root.change_view
        }

        TabButton { label: "amplitude"; whenClick: lambda {footer.setTab(0)}; highlight_pos: :top}
        TabButton { label: "frequency"; whenClick: lambda {footer.setTab(1)}; highlight_pos: :top}
        TabButton { label: "filter";    whenClick: lambda {footer.setTab(2)}; highlight_pos: :top}
    }

    function set_amp(base)
    {
        footer.children[0].value = true
        gen.extern  = base
        env.extern  = base + "AmpEnvelope/"
        lfo.extern  = base + "AmpLfo/"
        gen.content = Qml::ZynAmpVoiceGeneral
        env.content = Qml::ZynAmpEnv
        lfo.content = Qml::ZynLFO
        env.children[0].whenClick = lambda {row1.setDataVis(:env, :amp)}
        lfo.children[0].whenClick = lambda {row1.setDataVis(:lfo, :amp)}
        env.children[0].toggleable = base + "PAmpEnvelopeEnabled"
        lfo.children[0].toggleable = base + "PAmpLfoEnabled"
    }

    function set_freq(base)
    {
        footer.children[1].value = true
        gen.extern  = base
        env.extern  = base + "FreqEnvelope/"
        lfo.extern  = base + "FreqLfo/"
        gen.content = Qml::ZynFreqGeneral
        env.content = Qml::ZynFreqEnv
        lfo.content = Qml::ZynLFO
        env.children[0].whenClick = lambda {row1.setDataVis(:env, :freq)}
        lfo.children[0].whenClick = lambda {row1.setDataVis(:lfo, :freq)}
        env.children[0].toggleable = base + "PFreqEnvelopeEnabled"
        lfo.children[0].toggleable = base + "PFreqLfoEnabled"
    }

    function set_filter(base)
    {
        footer.children[2].value = true
        gen.extern  = base + "VoiceFilter/"
        env.extern  = base + "FilterEnvelope/"
        lfo.extern  = base + "FilterLfo/"
        gen.content = Qml::ZynAnalogFilter
        env.content = Qml::ZynFilterEnv
        lfo.content = Qml::ZynLFO
        env.children[0].whenClick = lambda {row1.setDataVis(:env, :filter)}
        lfo.children[0].whenClick = lambda {row1.setDataVis(:lfo, :filter)}
        env.children[0].toggleable = base + "PFilterEnvelopeEnabled"
        gen.children[0].toggleable = base + "PFilterEnabled"
        lfo.children[0].toggleable = base + "PFilterLfoEnabled"
    }

    function set_vis_lfo(ext, tab)
    {
        e_  = {:filter    => "FilterLfo/",
               :amplitude => "AmpLfo/",
               :frequency => "FreqLfo/"}[tab]
        return if e_.nil?
        row1.extern  = ext + e_
        row1.content = Qml::LfoVis
        row1.children[0].children[0].extern = lfo.extern+"out"
    }

    function set_vis_env(ext, tab)
    {
        e_  = {:filter    => "FilterEnvelope/",
               :amplitude => "AmpEnvelope/",
               :frequency => "FreqEnvelope/"}[tab]
        return if e_.nil?
        row1.extern  = ext + e_
        row1.content = Qml::ZynEnvEdit
        #self.children[0].children[0].extern = env.extern+"out"
        env.children[0].whenModified = lambda {
            elm = row1.children[0]
            elm.refresh if elm.respond_to? :refresh
        }
    }

    function set_vis_filter(ext, dummy)
    {
        #puts "addglobal.filtertype = #{addglobal.filtertype}"
        row1.extern = ext + "GlobalFilter/"
        if(addglobal.filtertype == :formant)
            row1.content = Qml::ZynFormant
        else
            row1.content = Qml::VisFilter
            row1.children[0].extern = ext + "GlobalFilter/response"
        end
        gen.children[0].whenModified = lambda {
            elm = row1.children[0]
            elm.refresh if elm.respond_to? :refresh
        }
    }

    function set_view()
    {
        subsubview = root.get_view_pos(:subsubview)
        types = [:amplitude, :frequency, :filter]
        if(!types.include?(subsubview))
            subsubview = :amplitude
            root.set_view_pos(:subsubview, subsubview)
        end

        vis = root.get_view_pos(:vis)
        types = [:envelope, :lfo, :filter]
        if(!types.include?(vis))
            vis = :envelope
            root.set_view_pos(:vis, vis)
        end

        base = self.extern

        if(subsubview == :amplitude)
            set_amp base
        elsif(subsubview == :frequency)
            set_freq base
        else
            set_filter base
        end

        if(vis == :lfo)
            set_vis_lfo(base, subsubview)
        elsif(vis == :envelope)
            set_vis_env(base, subsubview)
        elsif(vis == :filter)
            set_vis_filter(base, subsubview)
        end
    }

    function onSetup(old=nil)
    {
        set_view()
    }
}
