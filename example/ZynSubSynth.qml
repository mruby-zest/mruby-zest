Widget {
    id: subsynth


    TabGroup {
        id: subtabs
        TabButton {label: "harmonic" }
        TabButton {label: "global" }
        TabButton {label: "bandwidth" }

        TriggerButton {
            id: oscillbutton
            layoutOpts: [:no_constraint];
            label: "   oscilloscope"
            whenValue: lambda {
            root.set_view_pos(:subview, :sub_global)
            root.set_view_pos(:vis, :oscilloscope)
            root.change_view
            subsynth.turn_off_tab()  
             }
        }

        CopyButton  { id: cpy; extern: subsynth.extern}
        PasteButton { extern: subsynth.extern}

        function layout(l, selfBox) {
            selfBox = Draw::Layout::tabpack(l, selfBox, self, oscillbutton)
        }

        function set_tab(wid)
        {
            selected = get_tab wid

            #Define a mapping from tabs to values
            mapping = {0 => :harmonic,
                       1 => :sub_global,
                       2 => :bandwidth
                       }
            return if !mapping.include?(selected)
            root.set_view_pos(:subview, mapping[selected])
            root.change_view
        }
    }
    
    Swappable { id: swap }

    function layout(l, selfBox) {
        Draw::Layout::vfill(l, selfBox, children, [0.05, 0.95])
    }

    function set_view()
    {
        vw = root.get_view_pos(:subview)
        mapping = {:harmonic  => Qml::ZynSubHarmonic,
                   :sub_global => Qml::ZynSubGlobal,
                   :bandwidth => Qml::ZynSubBandwidth}
        tabid   = {:harmonic  => 0,
                   :sub_global => 1,
                   :bandwidth => 2}
        if(!mapping.include?(vw))
            root.set_view_pos(:subview, :harmonic)
            vw = :harmonic
        end

        swap.extern  = subsynth.extern
        swap.content = mapping[vw]
        subtabs.children[tabid[vw]].value = true
    }

    function onSetup(old=nil)
    {
        set_view
    }

    function turn_off_tab()
    {
        n = 5
        (0..n).each do |ch_id|
            child = subtabs.children[ch_id]
           
                if(child.value)
                    child.value = false
                    child.damage_self
                end
            end
    }
}
