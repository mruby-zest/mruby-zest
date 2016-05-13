Widget {
    id: selector
    property String extern: ""
    property Array  options: ["text", "test", "asdf"];
    property Int    selected: 0
    
    function class_name()
    {
        "Selector"
    }

    function onMousePress(ev)
    {
        if(selector.selected  >= (options.length - 1))
            selector.selected = 0
        else
            selector.selected = selector.selected + 1
        end
        if(selector.root)
            selector.root.damage_item selector
        end
    }

    function draw(vg)
    {
        vg.path do |v|
            v.rect(w/4, h/4, w/2, h/2)
            v.fill_color(NVG.rgba(0, 0, 128, 255))
            v.fill
        end
        
        vg.font_face("bold")
        vg.font_size h/2
        vg.text_align NVG::ALIGN_CENTER | NVG::ALIGN_MIDDLE
        vg.fill_color(NVG.rgba(0x3a,0xc5,0xec,255))
        vg.text(w/2,h/2,options[selected].upcase)
    }
}
