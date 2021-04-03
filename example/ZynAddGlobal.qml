Widget {
    id: addglobal

    property Object valueRef: nil
    property Symbol filtertype: nil


    function layout(l, selfBox)
    {
        Draw::Layout::vfill(l, selfBox, children, [0.55, 0.40, 0.05])
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
        function layout(l, selfBox) {
            Draw::Layout::hfill(l, selfBox, children, [0.23, 0.2, 0.4, 0.17])
        }


        Swappable {
            id: amp_gen
            whenSwapped: lambda {
                if(amp_gen.content == Qml::ZynAnalogFilter)
                    ch = amp_gen.children[0]
                    ch.whenClick = lambda {row1.setDataVis(:filter, :filter)}
                end
            }
        }
        Swappable {
            id: amp_env
        }
        Swappable {
            id: amp_lfo
        }
        Swappable {
            id: amp_seq
        }
    }
    Widget {
        id: footer

        function layout(l, selfBox) {
            selfBox = Draw::Layout::tabpack(l, selfBox, self)
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
            #db.update_values
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
        types = [:envelope, :lfo, :seq, :filter, :oscilloscope]
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
        elsif(vis == :seq)
            set_vis_seq(self.extern, subsubview)
        elsif(vis == :envelope)
            set_vis_env(self.extern, subsubview)
        elsif(vis == :oscilloscope)
            set_vis_oscilloscope()
        elsif(vis == :filter)
            set_vis_filter(self.extern, subsubview)
        end
        db.update_values
    }

    function set_vis_seq(ext, tab)
    {
        e_  = {:filter    => "FilterSeq/",
               :amplitude => "AmpSeq/",
               :frequency => "FreqSeq/"}[tab]
        return if e_.nil?
        row1.extern  = ext + e_
        row1.content = Qml::SeqVis
        row1.children[0].children[0].extern = amp_seq.extern
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
        if(addglobal.filtertype == :formant)
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
        amp_seq.extern  = base + "AmpSeq/"
        amp_gen.content = Qml::ZynAmpGeneral
        amp_env.content = Qml::ZynAmpEnv
        amp_lfo.content = Qml::ZynLFO
        amp_seq.content = Qml::ZynSEQ
        amp_env.children[0].whenClick = lambda {row1.setDataVis(:env, :amp)}
        amp_lfo.children[0].whenClick = lambda {row1.setDataVis(:lfo, :amp)}
        amp_seq.children[0].whenClick = lambda {row1.setDataVis(:seq, :amp)}
    }

    function set_freq(base)
    {
        footer.children[1].value = true
        amp_gen.extern  = base
        amp_env.extern  = base + "FreqEnvelope/"
        amp_lfo.extern  = base + "FreqLfo/"
        amp_seq.extern  = base + "FreqSeq/"
        amp_gen.content = Qml::ZynFreqGeneral
        amp_env.content = Qml::ZynFreqEnv
        amp_lfo.content = Qml::ZynLFO
        amp_seq.content = Qml::ZynSEQ
        amp_env.children[0].whenClick = lambda {row1.setDataVis(:env, :freq)}
        amp_lfo.children[0].whenClick = lambda {row1.setDataVis(:lfo, :freq)}
        amp_seq.children[0].whenClick = lambda {row1.setDataVis(:seq, :freq)}
    }

    function set_filter(base)
    {
        footer.children[2].value = true
        amp_gen.extern  = base + "GlobalFilter/"
        amp_env.extern  = base + "FilterEnvelope/"
        amp_lfo.extern  = base + "FilterLfo/"
        amp_seq.extern  = base + "FilterSeq/"
        amp_gen.content = Qml::ZynAnalogFilter
        amp_env.content = Qml::ZynFilterEnv
        amp_lfo.content = Qml::ZynLFO
        amp_seq.content = Qml::ZynSEQ
        amp_env.children[0].whenClick = lambda {row1.setDataVis(:env, :filter)}
        amp_lfo.children[0].whenClick = lambda {row1.setDataVis(:lfo, :filter)}
        amp_seq.children[0].whenClick = lambda {row1.setDataVis(:seq, :filter)}
    }

     function set_vis_oscilloscope()
    {
        row1.content = Qml::ZynAddOscilloscope
    }

    function onSetup(old=nil)
    {
        return if self.valueRef
        if(self.valueRef.nil?)
            path = self.extern + "GlobalFilter/Pcategory"
            self.valueRef = OSC::RemoteParam.new($remote, path)
            self.valueRef.mode = :full
            self.valueRef.callback = lambda {|x|
                addglobal.filtertype = [:analog, :formant, :statevar][x]
            }
        end
        set_view()
    }
}
