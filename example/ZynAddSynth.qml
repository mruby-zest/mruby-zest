Widget {
    id: center

    function layout(l)
    {
        #Center layout
        selfBox = l.genBox :zynCenter, center
        headBox  = header.layout(l)
        swapBox  = swap.layout(l)

        #module layout done
        l.contains(selfBox, headBox)
        l.contains(selfBox, swapBox)

        #Global Optimizatoin
        l.topOf(headBox, swapBox)

        l.sheq([headBox.h, selfBox.h], [1, -0.05], 0)

        selfBox
    }
    Widget {
        id: header
        NumEntry  {
            value:      header.get_voice
            whenValue:  lambda {header.set_voice()}
            layoutOpts: [:free]
            tooltip:    "voice"
            maximum:    7
        }
        TabButton { whenClick: lambda {header.setTab(0)}; label: "global"}
        TabButton { whenClick: lambda {header.setTab(1)}; label: "voice"}
        TabButton { whenClick: lambda {header.setTab(2)}; label: "osc"}
        TabButton { whenClick: lambda {header.setTab(3)}; label: "mod-osc"}
        TabButton { whenClick: lambda {header.setTab(4)}; label: "modulation"}
        TabButton { whenClick: lambda {header.setTab(5)}; label: "voice list"}
        TabButton { whenClick: lambda {header.setTab(6)}; label: "resonance"}

        CopyButton {}
        PasteButton {}

        function set_voice() {
            root.set_view_pos(:voice, children[0].value)
            root.change_view
        }
        function get_voice() { root.get_view_pos(:voice) }

        function gen_weights()
        {
            total   = 0
            weights = []
            children.each do |ch|
                scale = 100
                $vg.font_size scale
                label = ch.label
                label = "- 9999 +" if ch.class == Qml::NumEntry
                weight   = $vg.text_bounds(0, 0, label.upcase + "  ")
                weights << weight
                total   += weight
            end
            return total, weights
        }

        function layout(l)
        {
            selfBox = l.genBox :zynCenterHeader, self
            prev = nil

            (total, weights) = gen_weights

            children.each_with_index do |ch, idx|
                box = ch.layout(l)
                l.contains(selfBox,box)

                if(idx < 8)
                    l.sh([box.w, selfBox.w], [1, -(1-1e-4)*weights[idx]/total], 0)

                    #add in the aspect constraint
                    l.aspect(box, 100, weights[idx])
                elsif(idx == 8)
                    l.weak(box.x)
                end

                if(prev)
                    l.rightOf(prev, box)
                end
                prev = box
            end
            selfBox
        }


        function setTab(id)
        {
            n = children.length
            tab_id = 0
            (0..n).each do |ch_id|
                child = children[ch_id]
                if(child.class == Qml::TabButton)
                    child.value = (tab_id == id)
                    tab_id += 1
                    self.root.damage_item child
                end
            end

            #Define a mapping from tabs to values
            mapping = {0 => :global,
                       1 => :voice,
                       2 => :oscil,
                       3 => :modosc,
                       4 => :modulate,
                       5 => :vce_list,
                       6 => :resonance}

            root.set_view_pos(:subview, mapping[id])
            root.change_view

            #swap.force_update
            #swap.children[0].voice_button.value = true if(id == 2)
            #swap.children[0].mod_button.value   = true if(id == 3)
        }

    }

    function onSetup(old=nil)
    {
        return if swap.content
        set_view
    }

    function set_view()
    {
        vce     = root.get_view_pos(:voice)
        subview = root.get_view_pos(:subview)
        extbase = center.extern
        ext = {:global    => "GlobalPar/",
               :voice     => "VoicePar#{vce}/",
               :oscil     => "VoicePar#{vce}/OscilSmp/",
               :modosc    => "VoicePar#{vce}/FMSmp/",
               :modulate  => "VoicePar#{vce}/",
               :vce_list  => "",
               :resonance => "GlobalPar/Reson/"}
        mapping = {:global    => Qml::ZynAddGlobal,
                   :voice     => Qml::ZynAddVoice,
                   :oscil     => Qml::ZynOscil,
                   :modosc    => Qml::ZynOscil,
                   :modulate  => Qml::ZynOscilMod,
                   :vce_list  => Qml::ZynAddVoiceList,
                   :resonance => Qml::ZynResonance}
        tabid   = {:global    => 1,
                   :voice     => 2,
                   :oscil     => 3,
                   :modosc    => 4,
                   :modulate  => 5,
                   :vce_list  => 6,
                   :resonance => 6}
        if(!mapping.include?(subview))
            subview = :global
            root.set_view_pos(:subview, :global)
        end

        swap.extern  = extbase + ext[subview]
        swap.content = mapping[subview]
        header.children[tabid[subview]].value = true
    }

    Swappable { id: swap }
}
