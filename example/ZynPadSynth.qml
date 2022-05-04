Widget {
    id: center

    function layout(l, selfBox) {
        Draw::Layout::vfill(l, selfBox, children, [0.05, 0.95])
    }

    function apply() {
        $remote.action(center.extern+"prepare")
    }

    TabGroup {
        id: header
        TabButton { label: "harmonic structure";}
        TabButton { label: "oscillator";}
        TabButton { label: "envelopes & lfos"; whenClick: lambda {root.set_view_pos(:vis, :envelope)};}
        TabButton { whenClick: lambda {header.set_tab(3)}; label: "resonance"}

        ApplyButton {
            id: appl
            layoutOpts: [:no_constraint];
            label: "   apply"
            extern: center.extern + "needPrepare"
            whenValue: lambda {center.apply() }
        }
        TriggerButton {
            id: oscillbutton
            layoutOpts: [:no_constraint];
            label: "   oscilloscope"
            whenValue: lambda {
            root.set_view_pos(:subview, :global_pad)
            root.set_view_pos(:vis, :oscilloscope)
            root.change_view
            center.turn_off_tab()
             }
        }

        CopyButton {
            id: copy
            extern: center.extern
        }
        PasteButton {
            id: paste
            extern: center.extern
        }

        function layout(l, selfBox) {
            selfBox = Draw::Layout::tabpack(l, selfBox, self, appl)
        }

        function set_tab(wid)
        {
            selected = get_tab wid

            #Define a mapping from tabs to values
            mapping = {0 => :harmonics,
                       1 => :oscil,
                       2 => :global_pad,
                       3 => :resonance,
                       4 => :oscilloscope}
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
                   :global_pad  => Qml::ZynPadGlobal,
                   :resonance => Qml::ZynResonance,
                   :oscilloscope => Qml::ZynPadOscilloscope}
        base = center.extern
        ext     = {:harmonics  => "",
                   :oscil      => "oscilgen/",
                   :global_pad => "",
                   :resonance => "resonance/",
                   :oscilloscope => ""}
        tabid   = {:harmonics  => 0,
                   :oscil      => 1,
                   :global_pad => 2,
                   :resonance => 3,
                   :oscilloscope => 4}
        if(!mapping.include?(subview))
            subview = :oscil
            root.set_view_pos(:subview, :oscil)
        end


        copy.extern  = base + ext[subview]
        paste.extern = base + ext[subview]
        swap.extern  = base + ext[subview]
        swap.content = mapping[subview]
        header.children[tabid[subview]].value = true
    }

    Swappable { id: swap }

    function turn_off_tab()
    {
        n = 2
        (0..n).each do |ch_id|
            child = header.children[ch_id]

                if(child.value)
                    child.value = false
                    child.damage_self
                end
            end
    }
}
