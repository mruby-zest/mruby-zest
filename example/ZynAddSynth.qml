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
        Button { label: "<"; layoutOpts: [:no_constraint]}
        Button { label: "4"; layoutOpts: [:no_constraint]}
        Button { label: ">"; layoutOpts: [:no_constraint]}
        TabButton { whenClick: lambda {header.setTab(0)}; label: "global"; value: true}
        TabButton { whenClick: lambda {header.setTab(1)}; label: "voice"}
        TabButton { whenClick: lambda {header.setTab(2)}; label: "osc"}
        TabButton { whenClick: lambda {header.setTab(3)}; label: "mod-osc"}
        TabButton { whenClick: lambda {header.setTab(4)}; label: "modulation"}
        TabButton { whenClick: lambda {header.setTab(5)}; label: "voice list"}
        TabButton { whenClick: lambda {header.setTab(6)}; label: "resonance"}

        CopyButton {}
        PasteButton {}
        function gen_weights()
        {
            total   = 0
            weights = []
            children.each do |ch|
                scale = 100
                $vg.font_size scale
                weight   = $vg.text_bounds(0, 0, ch.label.upcase + "  ")
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

                if(idx < 10)
                    l.sh([box.w, selfBox.w], [1, -(1-1e-4)*weights[idx]/total], 0)

                    #add in the aspect constraint
                    l.aspect(box, 100, weights[idx])
                elsif(idx == 10)
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
            extbase = "/part0/kit0/adpars/"
            ext = {0 => "GlobalPar/",
                   1 => "VoicePar0/",
                   2 => "VoicePar0/OscilSmp/",
                   3 => "VoicePar0/FMSmp/",
                   4 => "VoicePar0/",
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
