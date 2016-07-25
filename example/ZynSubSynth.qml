Widget {
    id: subsynth

    Swappable { id: swap }

    TabGroup {
        id: subtabs
        TabButton {label: "harmonic" }
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
            mapping = {0 => :harmonic,
                       1 => :amplitude,
                       2 => :bandwidth,
                       3 => :frequency,
                       4 => :filter,
                       }
            return if !mapping.include?(selected)
            root.set_view_pos(:subview, mapping[selected])
            root.change_view

            #swap.extern  = "/part0/kit0/subpars/"
            #swap.content = mapping[selected]
        }
    }

    function layout(l) {
        selfBox = l.genBox :subsynth, self
        Draw::Layout::vfill(l, selfBox, chBoxes(l), [0.95, 0.05])
    }

    function set_view()
    {
        vw = root.get_view_pos(:subview)
        mapping = {:harmonic  => Qml::ZynSubHarmonic,
                   :amplitude => Qml::ZynSubAmp,
                   :bandwidth => Qml::ZynSubBandwidth,
                   :frequency => Qml::ZynSubFreq,
                   :filter    => Qml::ZynSubFilter}
        tabid   = {:harmonic  => 0,
                   :amplitude => 1,
                   :bandwidth => 2,
                   :frequency => 3,
                   :filter    => 4}
        if(!mapping.include?(vw))
            root.set_view_pos(:subview, :harmonic)
            vw = :harmonic
        end

        puts "subsynth extern is #{subsynth.extern}"
        swap.extern  = subsynth.extern
        swap.content = mapping[vw]
        subtabs.children[tabid[vw]].value = true
    }

    function onSetup(old=nil)
    {
        set_view
    }
}
