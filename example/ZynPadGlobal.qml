Widget {
    id: padglobal

    property Object valueRef: nil
    property Symbol filtertype: nil


    function layout(l, selfBox) {
        puts "pad global = #{selfBox}"
        Draw::Layout::vfill(l, selfBox, children, [0.55, 0.4, 0.05])
    }

    Swappable {
        id: row1
        content: Qml::LfoVis

        function setDataVis(type, tab) {
            root.set_view_pos(:vis, type)
            root.change_view
        }
    }

    Widget {
        id: row2
        function layout(l, selfBox) {
            puts "pad row2 = #{selfBox}"
            Draw::Layout::hpack(l, selfBox, children)
        }


        Swappable { id: amp_gen }
        Swappable { id: amp_env }
        Swappable { id: amp_lfo }
    }
    Widget {
        id: footer

        function layout(l, selfBox) {
            Draw::Layout::tabpack(l, selfBox, self)
        }

        function setTab(id)
        {
            (0..2).each do |ch_id|
                children[ch_id].value = (ch_id == id)
                children[ch_id].damage_self
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

        if(subsubview == :amplitude)
            set_amp(self.extern)
        elsif(subsubview == :frequency)
            set_freq(self.extern)
        elsif(subsubview == :filter)
            set_filter(self.extern)
        end

        if(vis == :lfo)
            set_vis_lfo(self.extern, subsubview)
        elsif(vis == :envelope)
            set_vis_env(self.extern, subsubview)
        elsif(vis == :filter)
            set_vis_filter(self.extern, subsubview)
        end
        db.update_values
    }

    function set_vis_lfo(ext, tab)
    {
        e_  = {:filter    => "FilterLfo/",
               :amplitude => "AmpLfo/",
               :frequency => "FreqLfo/"}[tab]
        return if e_.nil?
        row1.extern  = ext + e_
        row1.content = Qml::LfoVis
        row1.children[0].children[0].extern = amp_lfo.extern+"out"
    }

    function set_vis_env(ext, tab)
    {
        e_  = {:filter    => "FilterEnvelope/",
               :amplitude => "AmpEnvelope/",
               :frequency => "FreqEnvelope/"}[tab]
        return if e_.nil?
        row1.extern  = ext + e_
        row1.content = Qml::ZynEnvEdit
        #self.children[0].children[0].extern = amp_env.extern+"out"
        amp_env.children[0].whenModified = lambda {
            elm = row1.children[0]
            elm.refresh if elm.respond_to? :refresh
        }
    }

    function set_vis_filter(ext, dummy)
    {
        row1.extern = ext + "GlobalFilter/"
        if(self.filtertype == :formant)
            row1.content = Qml::ZynFormant
        else
            row1.content = Qml::VisFilter
            row1.children[0].extern = ext + "GlobalFilter/response"
        end
        amp_gen.children[0].whenModified = lambda {
            elm = row1.children[0]
            elm.refresh if elm.respond_to? :refresh
        }
    }

    function set_amp(base)
    {
        footer.children[0].value = true
        amp_gen.extern  = base
        amp_env.extern  = base + "AmpEnvelope/"
        amp_lfo.extern  = base + "AmpLfo/"
        amp_gen.content = Qml::ZynPadAmp
        amp_env.content = Qml::ZynAmpEnv
        amp_lfo.content = Qml::ZynLFO
        amp_env.children[0].whenClick = lambda {row1.setDataVis(:env, :amp)}
        amp_lfo.children[0].whenClick = lambda {row1.setDataVis(:lfo, :amp)}
    }

    function set_freq(base)
    {
        footer.children[1].value = true
        amp_gen.extern  = base
        amp_env.extern  = base + "FreqEnvelope/"
        amp_lfo.extern  = base + "FreqLfo/"
        amp_gen.content = Qml::ZynPadFreq
        amp_env.content = Qml::ZynFreqEnv
        amp_lfo.content = Qml::ZynLFO
        amp_env.children[0].whenClick = lambda {row1.setDataVis(:env, :freq)}
        amp_lfo.children[0].whenClick = lambda {row1.setDataVis(:lfo, :freq)}
    }

    function set_filter(base)
    {
        footer.children[2].value = true
        amp_gen.extern  = base + "GlobalFilter/"
        amp_env.extern  = base + "FilterEnvelope/"
        amp_lfo.extern  = base + "FilterLfo/"
        amp_gen.content = Qml::ZynAnalogFilter
        amp_env.content = Qml::ZynFilterEnv
        amp_lfo.content = Qml::ZynLFO
        amp_gen.children[0].whenClick = lambda {row1.setDataVis(:filter, :filter)}
        amp_env.children[0].whenClick = lambda {row1.setDataVis(:env,    :filter)}
        amp_lfo.children[0].whenClick = lambda {row1.setDataVis(:lfo,    :filter)}
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
        set_view()
    }
}
