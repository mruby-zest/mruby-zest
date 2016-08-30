Widget {
    TabGroup {
        TabButton {value: true; label: "system" }
        TabButton {label: "insertion" }
        TabButton {label: "part insertion" }
        
        function set_tab(wid)
        {
            selected = get_tab wid
            if(selected == 0)
                root.set_view_pos(:subview, :sysefx)
            elsif(selected == 1)
                root.set_view_pos(:subview, :insefx)
            elsif(selected == 2)
                root.set_view_pos(:subview, :prtefx)
            end
            root.change_view
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

    function set_view()
    {
        sub = root.get_view_pos(:subview)
        if(![:sysefx, :insefx, :prtefx].include?(sub))
            sub = :sysefx
            root.set_view_pos(:subview, sub)
        end

        if(sub == :sysefx)
            swap.content = Qml::ZynEffectsSystem
        elsif(sub == :insefx)
            swap.content = Qml::ZynEffectsInsert
        elsif(sub == :prtefx)
            prt = root.get_view_pos(:part)
            swap.extern = "/part#{prt}/"
            swap.content = Qml::ZynEffectsPart
        end
    }
}
