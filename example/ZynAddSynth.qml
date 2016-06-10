Widget {
    id: center

    function draw(vg)
    {
        bg_color      = color("424B56")
        vg.path do |v|
            v.rect(0, 0, self.w, self.h)
            v.fill_color(bg_color)
            v.fill
        end
    }
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


        function layout(l)
        {
            selfBox = l.genBox :zynCenterHeader, header
            prev = nil

            total   = 0
            weights = []
            header.children.each do |ch|
                scale = 100
                $vg.font_size scale
                weight   = $vg.text_bounds(0, 0, ch.label.upcase + "  ")
                weights << weight
                total   += weight
            end

            header.children.each_with_index do |ch, idx|
                box = ch.layout(l)
                l.contains(selfBox,box)

                l.sh([box.w, selfBox.w], [1, -(1-1e-4)*weights[idx]/total], 0)

                #add in the aspect constraint
                l.aspect(box, 100, weights[idx])

                #print "layout weights "
                #puts weights[idx]/total
                if(prev)
                    l.rightOf(prev, box)
                end
                prev = box
            end
            selfBox
        }

        function setTab(id)
        {
            N = children.length
            tab_id = 0
            (0..N).each do |ch_id|
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

        Button { label: "<"; layoutOpts: [:no_constraint]}
        Button { label: "4"; layoutOpts: [:no_constraint]}
        Button { label: ">"; layoutOpts: [:no_constraint]}
        TabButton { whenClick: lambda {header.setTab(0)}; label: "global"; value: true}
        TabButton { whenClick: lambda {header.setTab(1)}; label: "voice"}
        TabButton { whenClick: lambda {header.setTab(2)}; label: "oscillators"}
        TabButton { whenClick: lambda {header.setTab(3)}; label: "modulation"}
        TabButton { whenClick: lambda {header.setTab(4)}; label: "voice list"}
        TabButton { whenClick: lambda {header.setTab(5)}; label: "resonance"}
        Button { label: "c"; layoutOpts: [:no_constraint]}
        Button { label: "p"; layoutOpts: [:no_constraint]}
    }

    Swappable {
        id: swap
        content: Qml::ZynAddGlobal
    }
}
