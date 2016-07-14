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
    TabGroup {
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

        function set_tab(wid)
        {
            selected = get_tab wid

            #Define a mapping from tabs to values
            mapping = {0 => Qml::ZynSubHarmonic,
                       1 => Qml::ZynSubAmp,
                       2 => Qml::ZynSubBandwidth,
                       3 => Qml::ZynSubFreq,
                       4 => Qml::ZynSubFilter,
                       }

            swap.extern  = "/part0/kit0/subpars/"
            swap.content = mapping[selected]
        }
    }

    function layout(l) {
        selfBox = l.genBox :subsynth, self
        Draw::Layout::vfill(l, selfBox, chBoxes(l), [0.95, 0.05])
    }
}
