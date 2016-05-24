Widget {
    id: button
    property signal action: nil;
    property String extern:   "";
    property Bool   value:    false;
    property String renderer: nil;

    function onMousePress(ev) {
        puts "Button Press"
        button.value = !button.value
        if(root)
            root.damage_item self
        end
    }

    function onMerge(val)
    {
        button.value = val.value
    }

    function class_name()
    {
        "KitButton"
    }

    function layout(l)
    {
        t = widget.class_name.to_sym
        l.genBox t, widget
    }

    function draw(vg)
    {
        off_color     = NVG.rgba(0x3A,0x42,0x4D,255)
        outline_color = NVG.rgba(0x00,0x89,0xb9,255)
        text_color1   = NVG.rgba(0x00,0xc2,0xea,255)
        text_color2   = NVG.rgba(0x00,0xc2,0xea,255)
        pad = 1/32
        vg.path do |v|
            v.rect(w*pad, h*pad, w*(1-2*pad), h*(1-2*pad))
            if(button.value)
                v.fill_color(NVG.rgba(0, 255, 0, 255))
            else
                v.fill_color(off_color)
            end
            #v.stroke_color(outline_color)
            v.fill
            #v.stroke_width 1
            #v.stroke
        end

        vg.font_face("bold")
        vg.font_size (h*0.75).to_i
        vg.text_align NVG::ALIGN_CENTER | NVG::ALIGN_MIDDLE
        if(value)
            vg.fill_color(text_color1)
        else
            vg.fill_color(text_color2)
        end
        vg.text(w/2,h/2,button.label.upcase)
    }
}
