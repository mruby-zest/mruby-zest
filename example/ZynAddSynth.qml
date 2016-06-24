Widget {
    id: center

    function layout(l)
    {
        #puts "Center layout"
        selfBox = l.genBox :zynCenter, center
        headBox  = header.layout(l)
        swapBox  = swap.layout(l)

        #puts "module layout done"
        l.contains(selfBox, headBox)
        l.contains(selfBox, swapBox)

        #Global Optimizatoin
        l.topOf(headBox, swapBox)

        l.sheq([headBox.h, selfBox.h], [1, -0.05], 0)

        selfBox
    }
    Widget {
        id: header
        Widget {
            Button { label: "<"; layoutOpts: [:no_constraint]}
            Button { label: "4"; layoutOpts: [:no_constraint]}
            Button { label: ">"; layoutOpts: [:no_constraint]}
            TabButton { whenClick: lambda {header.setTab(0)}; label: "global"; value: true}
            TabButton { whenClick: lambda {header.setTab(1)}; label: "voice"}
            TabButton { whenClick: lambda {header.setTab(2)}; label: "oscillators"}
            TabButton { whenClick: lambda {header.setTab(3)}; label: "modulation"}
            TabButton { whenClick: lambda {header.setTab(4)}; label: "voice list"}
            TabButton { whenClick: lambda {header.setTab(5)}; label: "resonance"}
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
        }
        
        CopyButton {}
        PasteButton {}

        function layout(l)
        {
            selfBox = l.genBox :adsynthhead, self
            ch = children.map {|x| x.layout l}
            l.contains(selfBox, ch[0])
            l.contains(selfBox, ch[1])
            l.contains(selfBox, ch[2])
            l.weak(ch[1].x)
            l.rightOf(ch[0], ch[1])
            l.rightOf(ch[1], ch[2])
            l.sheq([ch[2].x, ch[2].w, selfBox.w], [1, 1, -1], 0)
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
            mapping = {0 => Qml::ZynAddGlobal,
                       1 => Qml::ZynAddVoice,
                       2 => Qml::ZynOscil,
                       3 => Qml::ZynOscilMod,
                       4 => Qml::ZynAddVoiceList,
                       5 => Qml::ZynResonance}

            swap.content = mapping[id]
        }

    }

    Swappable {
        id: swap
        content: Qml::ZynAddGlobal
    }
}
