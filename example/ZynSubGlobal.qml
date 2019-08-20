Widget {
    id: subglobal

    property Object valueRef: nil
    property Symbol filtertype: nil


    function layout(l, selfBox) {
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

  Widget 
    {
        id: row2
        function layout(l, selfBox) {
            Draw::Layout::hpack(l, selfBox, children)
        }


        Swappable { id: gen }
        Swappable { id: env }
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
        types = [:amplitude, :frequency, :filter, :envelope]
        if(!types.include?(subsubview))
            subsubview = :amplitude
            root.set_view_pos(:subsubview, subsubview)
        end

        vis = root.get_view_pos(:vis)
        types = [:amplitude, :frequency, :filter, :oscilloscope]
        if(!types.include?(vis))
            vis = :amplitude
            root.set_view_pos(:vis, vis)
        end

        if(subsubview == :amplitude)
            set_amp(self.extern)
        elsif(subsubview == :frequency)
            set_freq(self.extern)
        elsif(subsubview == :filter)
            set_filter(self.extern)
        end

         if(vis == :amplitude)
            set_vis_amp(self.extern)
        elsif(vis == :frequency)
            set_vis_freq(self.extern)
        elsif(vis == :filter)
            set_vis_filter(self.extern)
        elsif(vis == :oscilloscope)
            set_vis_oscilloscope()
        elsif(vis == :envelope)
            set_vis_env(self.extern)
        end
        db.update_values
    }

      function set_amp(base)
    {
        footer.children[0].value = true
        gen.extern = base
        env.extern  = base + "AmpEnvelope/"
        gen.content = Qml::ZynSubAmpbutton
        env.content = Qml::ZynAmpEnv
    }

    function set_freq(base)
    {
        footer.children[1].value = true
        gen.extern = base
        env.extern  = base + "FreqEnvelope/"
        gen.content = Qml::ZynSubFreqbutton
        env.content = Qml::ZynFreqEnv
    }

    function set_filter(base)
    {
        footer.children[2].value = true
        gen.extern = base + "GlobalFilter/"
        env.extern  = base + "GlobalFilterEnvelope/"
        gen.content = Qml::ZynSubAnalogFilter
        env.content = Qml::ZynSubFilterEnv
        
    }

      function set_vis_amp(ext)
    {
        row1.extern  = ext + "AmpEnvelope/"
        row1.content = Qml::ZynEnvEdit
    }

    function set_vis_filter(ext)
    {
        add_cat()
        #row1.extern  = ext + "FreqEnvelope/"

         if(self.filtertype == :formant)
            row1.content = Qml::ZynFormant
        else
            row1.extern = ext + "GlobalFilter/response"
            row1.content = Qml::VisFilter
        end
    }

    function set_vis_oscilloscope()
    {
        row1.content = Qml::ZynSubOscilloscope
    }

     function set_vis_env(ext)
    {
        row1.extern  = ext + "GlobalFilterEnvelope/"
        row1.content = Qml::ZynEnvEdit
        row1.whenModified = lambda {
            elm = row1.children[0]
            elm.refresh if elm.respond_to? :refresh
        }
    }

      function add_cat()
    {
        return if self.valueRef
        if(self.valueRef.nil?)
            path = self.extern + "GlobalFilter/Pcategory"
            self.valueRef = OSC::RemoteParam.new($remote, path)
            self.valueRef.mode = :full
            self.valueRef.callback = lambda {|x|
                subglobal.filtertype = [:analog, :formant, :statevar][x]
            }
        end
    }

    
}