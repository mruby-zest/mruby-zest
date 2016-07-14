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

    function apply()
    {
        puts "extern = #{center.extern}"
        $remote.action(center.extern+"prepare")
    }
    TabGroup {
        id: header
        TabButton { label: "harmonic structure"; value: true}
        TabButton { label: "oscillator";}
        TabButton { label: "envelopes & lfos"}

        Button {
            layoutOpts: [:no_constraint];
            label: "apply"
            whenValue: lambda {center.apply() }
        }
        Button { layoutOpts: [:no_constraint]; label: "export" }
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
                elsif(idx == 4)
                    l.aspect(box, 100, weights[idx])
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
            mapping = {0 => :harmonics,
                       1 => :oscil,
                       2 => :global_pad}
            root.set_view_pos(:subview, mapping[selected])
            root.change_view
        }

    }
    function get_voice() { root.get_view_pos(:voice) }
    function get_part()  { root.get_view_pos(:part)  }
    function get_kit()   { root.get_view_pos(:kit)   }

    function onSetup(old=nil)
    {
        return if swap.content.nil?
        set_view
    }

    function set_view()
    {
        subview = root.get_view_pos(:subview)

        mapping = {:harmonics   => Qml::ZynPadHarmonics,
                   :oscil       => Qml::ZynOscil,
                   :global_pad  => Qml::ZynPadGlobal}
        base = center.extern
        ext     = {:harmonics  => "",
                   :oscil      => "oscilgen/",
                   :global_pad => ""}
        if(!mapping.include?(subview))
            subview = :harmonics
            root.set_view_pos(:subview, :harmonics)
        end


        swap.extern  = base + ext[subview]
        swap.content = mapping[subview]
    }

    Swappable { id: swap }
}
