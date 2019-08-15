Widget{

    extern: "/part0/kit0/subpars/"
    function layout(l, selfBox) {
        Draw::Layout::vfill(l, selfBox, children, [0.55, 0.4, 0.05])
    }

    ZynOscilloscope{
        options: ["SubNote", "subNote1"]
        opt_vals: ["/part0/kit0/subpars/noteout","/part0/kit0/subpars/noteout1"] 
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
        types = [:amplitude, :frequency, :filter]
        if(!types.include?(subsubview))
            subsubview = :amplitude
            root.set_view_pos(:subsubview, subsubview)
        end

        if(subsubview == :amplitude)
            set_amp(self.extern)
        elsif(subsubview == :frequency)
            set_freq(self.extern)
        elsif(subsubview == :filter)
            set_filter(self.extern)
        end

    }

      function set_amp(base)
    {
        footer.children[0].value = true
        env.extern  = base + "AmpEnvelope/"
        gen.content = Qml::ZynSubAmpbutton
        env.content = Qml::ZynAmpEnv
     

    }

    function set_freq(base)
    {
        footer.children[1].value = true
        env.extern  = base + "FreqEnvelope/"
        gen.content = Qml::ZynSubFreqbutton
        env.content = Qml::ZynFreqEnv
    }

    function set_filter(base)
    {
        footer.children[2].value = true
        gen.extern = base + "GlobalFilter/"
        env.extern  = base + "GlobalFilterEnvelope/"
        gen.content = Qml::ZynAnalogFilter
        env.content = Qml::ZynFilterEnv
    }
}
