Widget {
    id: addbase

    property Object valueRef: nil
    property Symbol filtertype: nil

    function layout(l, selfBox) {
        Draw::Layout::vfill(l, selfBox, children, 
                            [0.55, 0.40, 0.05])
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
        function layout(l, selfBox) {
            Draw::Layout::hpack(l, selfBox, children)
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
        Swappable {
            id: seq
        }
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
        seq.extern  = base + "AmpSeq/"
        gen.content = Qml::ZynAmpVoiceGeneral
        env.content = Qml::ZynAmpEnv
        lfo.content = Qml::ZynLFO
        seq.content = Qml::ZynSEQ
        env.children[0].whenClick = lambda {row1.setDataVis(:env, :amp)}
        lfo.children[0].whenClick = lambda {row1.setDataVis(:lfo, :amp)}
        seq.children[0].whenClick = lambda {row1.setDataVis(:seq, :amp)}
        env.children[0].toggleable = base + "PAmpEnvelopeEnabled"
        lfo.children[0].toggleable = base + "PAmpLfoEnabled"
        seq.children[0].toggleable = base + "PAmpSeqEnabled"
    }

    function set_freq(base)
    {
        footer.children[1].value = true
        gen.extern  = base
        env.extern  = base + "FreqEnvelope/"
        lfo.extern  = base + "FreqLfo/"
        seq.extern  = base + "FreqSeq/"
        gen.content = Qml::ZynFreqGeneralVoice
        env.content = Qml::ZynFreqEnv
        lfo.content = Qml::ZynLFO
        seq.content = Qml::ZynSEQ
        env.children[0].whenClick = lambda {row1.setDataVis(:env, :freq)}
        lfo.children[0].whenClick = lambda {row1.setDataVis(:lfo, :freq)}
        seq.children[0].whenClick = lambda {row1.setDataVis(:seq, :freq)}
        env.children[0].toggleable = base + "PFreqEnvelopeEnabled"
        lfo.children[0].toggleable = base + "PFreqLfoEnabled"
        seq.children[0].toggleable = base + "PFreqSeqEnabled"
    }

    function set_filter(base)
    {
        footer.children[2].value = true
        gen.extern  = base + "VoiceFilter/"
        env.extern  = base + "FilterEnvelope/"
        lfo.extern  = base + "FilterLfo/"
        seq.extern  = base + "FilterSeq/"
        gen.content = Qml::ZynAnalogFilter
        env.content = Qml::ZynFilterEnv
        lfo.content = Qml::ZynLFO
        seq.content = Qml::ZynSEQ
        gen.children[0].whenClick = lambda {row1.setDataVis(:filter, :filter)}
        env.children[0].whenClick = lambda {row1.setDataVis(:env, :filter)}
        lfo.children[0].whenClick = lambda {row1.setDataVis(:lfo, :filter)}
        seq.children[0].whenClick = lambda {row1.setDataVis(:seq, :filter)}
        env.children[0].toggleable = base + "PFilterEnvelopeEnabled"
        gen.children[0].toggleable = base + "PFilterEnabled"
        lfo.children[0].toggleable = base + "PFilterLfoEnabled"
        seq.children[0].toggleable = base + "PFilterSeqEnabled"
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

    function set_vis_seq(ext, tab)
    {
        e_  = {:filter    => "FilterSeq/",
               :amplitude => "AmpSeq/",
               :frequency => "FreqSeq/"}[tab]
        return if e_.nil?
        row1.extern  = ext + e_
        row1.content = Qml::SeqVis
        row1.children[0].children[0].extern = seq.extern+"out"
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
        row1.extern = ext + "VoiceFilter/"
        if(addbase.filtertype == :formant)
            row1.content = Qml::ZynFormant
        else
            row1.content = Qml::VisFilter
            row1.children[0].extern = ext + "VoiceFilter/response"
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
        types = [:envelope, :lfo, :filter, :seq]
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
        elsif(vis == :seq)
            set_vis_seq(base, subsubview)
        elsif(vis == :envelope)
            set_vis_env(base, subsubview)
        elsif(vis == :filter)
            set_vis_filter(base, subsubview)
        end
    }

    function onSetup(old=nil)
    {
        return if self.valueRef
        if(self.valueRef.nil?)
            path = self.extern + "VoiceFilter/Pcategory"
            self.valueRef = OSC::RemoteParam.new($remote, path)
            self.valueRef.mode = :full
            self.valueRef.callback = lambda {|x|
                addbase.filtertype = [:analog, :formant, :statevar][x]
            }
        end
        set_view()
    }
}
