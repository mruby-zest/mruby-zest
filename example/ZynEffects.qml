Widget {
    TabGroup {
        TabButton {value: true; label: "system" }
        TabButton {label: "insertion" }
        TabButton {label: "part insertion" }
        
        function set_tab(wid)
        {
            selected = get_tab wid
            if(selected == 0)
                swap.content = Qml::ZynEffectsSystem
            elsif(selected == 1)
                swap.content = Qml::ZynEffectsInsert
            elsif(selected == 2)
                swap.content = Qml::ZynEffectsPart
            end
        }
    }
    Swappable {
        id: swap
        content: Qml::ZynEffectsSystem
    }

    function layout(l)
    {
        Draw::Layout::vfill(l, self_box(l), chBoxes(l), [0.05, 0.95])
    }
}
