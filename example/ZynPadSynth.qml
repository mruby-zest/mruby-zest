Widget {
Widget {
    id: center

    function layout(l)
    {
        selfBox = l.genBox :zynCenter, center
        headBox  = header.layout(l)
        swapBox  = swap.layout(l)

        l.contains(selfBox, headBox)
        l.contains(selfBox, swapBox)

        #Global Optimizatoin
        l.topOf(headBox, swapBox)

        l.sheq([headBox.h, selfBox.h], [1, -0.05], 0)

        selfBox
    }
    TabGroup {
        id: header
        TabButton { label: "harmonic structure"; value: true}
        TabButton { label: "oscillator";}
        TabButton { label: "envelopes & lfos"}

        Button { layoutOpts: [:no_constraint]; label: "export"}
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

                if(idx < 3)
                    l.sh([box.w, selfBox.w], [1, -(1-1e-4)*weights[idx]/total], 0)

                    #add in the aspect constraint
                    l.aspect(box, 100, weights[idx])
                elsif(idx == 3)
                    l.aspect(box, 100, weights[idx])
                    l.weak(box.x)
                end

                if(prev)
                    l.rightOf(prev, box)
                end
                prev = box
            end
            selfBox
        }

        function set_tab(wid)
        {
            selected = get_tab wid

            #Define a mapping from tabs to values
            mapping = {0 => Qml::ZynPadHarmonics,
                       1 => Qml::ZynOscil,
                       2 => Qml::ZynAddGlobal}
            base = "/part0/kit0/padpars/"
            ext     = {0 => "",
                       1 => "oscilgen/",
                       2 => ""}


            swap.extern = base + ext[selected]
            swap.content = mapping[selected]
        }

    }

    Swappable {
        id: swap
        content: Qml::ZynPadHarmonics
    }
}
}
