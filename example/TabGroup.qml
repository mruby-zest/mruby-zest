Widget {
    function layout(l, selfBox) {
        puts "TabGroup = #{selfBox}"
        selfBox = Draw::Layout::tabpack(l, selfBox, self)
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
}
