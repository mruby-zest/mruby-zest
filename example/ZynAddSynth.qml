Widget {
    id: center

    function layout(l, selfBox)
    {
        Draw::Layout::vfill(l, selfBox, children, [0.05, 0.95])
    }
    Widget {
        id: header
        PowButton {id: vpow}
        NumEntry  {
            value:      header.get_voice + 1
            format:     "VCE "
            whenValue:  lambda {header.set_voice()}
            tooltip:    "voice"
            maximum:    8
            minimum:    1
        }

        TabButton { whenClick: lambda {header.setTab(0)}; label: "global"}
        TabButton { whenClick: lambda {header.setTab(1)}; label: "voice"}
        TabButton { whenClick: lambda {header.setTab(2)}; label: "oscillator"}
        TabButton { whenClick: lambda {header.setTab(3)}; label: "mod-osc"}
        TabButton { whenClick: lambda {header.setTab(4)}; label: "modulation"}
        TabButton { whenClick: lambda {header.setTab(5)}; label: "voice list"}
        TabButton { whenClick: lambda {header.setTab(6)}; label: "resonance"}


        TriggerButton {
            id: oscillbutton
            layoutOpts: [:no_constraint];
            label: "   oscilloscope"
            whenValue: lambda {
            root.set_view_pos(:subview, :oscilloscope)
            root.change_view
            center.turn_off_tab()  
             }
        }

        CopyButton  {id: cpy_but}
        PasteButton {id: pst_but}

        function set_voice() {
            root.set_view_pos(:voice, children[1].value-1)
            root.change_view
        }
        function get_voice() { root.get_view_pos(:voice) }

        function layout(l, selfBox) {
            selfBox = Draw::Layout::tabpack(l, selfBox, self, oscillbutton)
        }


        function setTab(id)
        {
            #Define a mapping from tabs to values
            mapping = {0 => :global,
                       1 => :voice,
                       2 => :oscil,
                       3 => :modosc,
                       4 => :modulate,
                       5 => :vce_list,
                       6 => :resonance,
                       7 => :oscilloscope}

            root.set_view_pos(:subview, mapping[id])
            root.change_view
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
               :resonance => "GlobalPar/Reson/",
               :oscilloscope => ""}
        mapping = {:global    => Qml::ZynAddGlobal,
                   :voice     => Qml::ZynAddVoice,
                   :oscil     => Qml::ZynOscil,
                   :modosc    => Qml::ZynOscil,
                   :modulate  => Qml::ZynOscilMod,
                   :vce_list  => Qml::ZynAddVoiceList,
                   :resonance => Qml::ZynResonance,
                   :oscilloscope => Qml::ZynAddOscilloscope}
        tabid   = {:global    => 2,
                   :voice     => 3,
                   :oscil     => 4,
                   :modosc    => 5,
                   :modulate  => 6,
                   :vce_list  => 7,
                   :resonance => 8,
                   :oscilloscope => 9}
        if(!mapping.include?(subview))
            subview = :oscil
            root.set_view_pos(:subview, :oscil)
        end

        swap.extern  = extbase + ext[subview]
        swap.content = mapping[subview]
        header.children.each_with_index do |ch, i|
            if(ch.class == Qml::TabButton)
                ch.value = (i == tabid[subview])
                ch.damage_self
            end
        end

        header.children[1].setValue(vce+1)

        cpy_but.index  = nil
        pst_but.index  = nil

        if([:oscil, :modosc, :resonance].include?(subview))
            cpy_but.extern = extbase + ext[subview]
            pst_but.extern = extbase + ext[subview]
        elsif([:modulate,:voice].include?(subview))
            cpy_but.extern = extbase
            pst_but.extern = extbase
            cpy_but.index  = vce
            pst_but.index  = vce
        else
            cpy_but.extern = extbase
            pst_but.extern = extbase
        end
        vpow.extern    = extbase + "VoicePar#{vce}/Enabled"

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
