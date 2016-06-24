Widget {
    id: subsynth

    function refresh()
    {
        sub_harmonics.refresh
    }
    Swappable {
        id: swap
        content: Qml::ZynSubHarmonic
    }
    Widget {
        id: subtabs
        TabButton {value: true; label: "harmonic" }
        TabButton {label: "amplitude" }
        TabButton {label: "bandwidth" }
        TabButton {label: "frequency" }
        TabButton {label: "filter" }

        function onSetup(old=nil) {
            children.each do |ch|
                ch.highlight_pos = :top
            end
        }

        function layout(l) {
            Draw::Layout::tabpack(l, self)
        }

        function get_tab(wid)
        {
            n = children.length
            selected = 0
            tab_id = 0
            (0..n).each do |ch_id|
                child = children[ch_id]
                if(child.class == Qml::TabButton)
                    if(wid == child)
                        child.value = true
                        selected = tab_id
                    else
                        if(child.value)
                            child.value = false
                            child.damage_self
                        end
                    end
                    tab_id += 1
                end
            end
            selected
        }

        function set_tab(wid)
        {
            n = children.length
            selected = get_tab wid

            #Define a mapping from tabs to values
            mapping = {0 => Qml::ZynSubHarmonic,
                       1 => Qml::ZynSubAmp,
                       2 => Qml::ZynSubBandwidth,
                       3 => Qml::ZynSubFreq,
                       3 => Qml::ZynSubFilter,
                       }

            swap.content = mapping[selected]
        }
    }

    function layout(l) {
        selfBox = l.genBox :subsynth, self
        Draw::Layout::vfill(l, selfBox, chBoxes(l), [0.95, 0.05])
    }
}
