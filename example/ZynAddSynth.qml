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
            whenValue:  lambda {header.set_voice()}
            layoutOpts: [:free]
            tooltip:    "voice"
            maximum:    7
        }
        TabButton { whenClick: lambda {header.setTab(0)}; label: "global"; value: true}
        TabButton { whenClick: lambda {header.setTab(1)}; label: "voice"}
        TabButton { whenClick: lambda {header.setTab(2)}; label: "osc"}
        TabButton { whenClick: lambda {header.setTab(3)}; label: "mod-osc"}
        TabButton { whenClick: lambda {header.setTab(4)}; label: "modulation"}
        TabButton { whenClick: lambda {header.setTab(5)}; label: "voice list"}
        TabButton { whenClick: lambda {header.setTab(6)}; label: "resonance"}

        CopyButton {}
        PasteButton {}

        function set_voice()
        {
            root.set_view_pos(:voice, children[0].value)
        }

        function get_voice() { root.get_view_pos(:voice) }
        function get_part()  { root.get_view_pos(:part)  }
        function get_kit()   { root.get_view_pos(:kit)   }

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
            puts weights
            puts children

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

        function get_ext(id)
        {
            kit = get_kit()
            prt = get_part()
            vce = get_voice()
            extbase = "/part#{prt}/kit#{kit}/adpars/"
            ext = {0 => "GlobalPar/",
                   1 => "VoicePar#{vce}/",
                   2 => "VoicePar#{vce}/OscilSmp/",
                   3 => "VoicePar#{vce}/FMSmp/",
                   4 => "VoicePar#{vce}/",
                   5 => "",
                   6 => "GlobalPar/Reson/"}
            extbase + ext[id]
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
            mapping = {0 => Qml::ZynAddGlobal,
                       1 => Qml::ZynAddVoice,
                       2 => Qml::ZynOscil,
                       3 => Qml::ZynOscil,
                       4 => Qml::ZynOscilMod,
                       5 => Qml::ZynAddVoiceList,
                       6 => Qml::ZynResonance}

            swap.extern = get_ext(id)
            swap.content = mapping[id]
            swap.force_update
            swap.children[0].voice_button.value = true if(id == 2)
            swap.children[0].mod_button.value   = true if(id == 3)
        }

    }

    Swappable {
        id: swap
        content: Qml::ZynAddGlobal
    }
}
