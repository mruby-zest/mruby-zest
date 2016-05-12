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
        "Button"
    }
    function layout(l)
    {
        t = widget.class_name.to_sym
        scale = 100
        $vg.font_size scale
        bb = $vg.text_bounds(0, 0, label.upcase)
        selfBox = l.genBox t, button
        if(bb != 0)
            #Width cannot be so small that letters overflow
            l.sh([selfBox.w, selfBox.h], [-1.0, bb/scale], 0)
        end
        selfBox
    }

    function draw(vg)
    {
        off_color     = NVG.rgba(0x04,0x37,0x5e,255)
        outline_color = NVG.rgba(0x00,0x89,0xb9,255)
        text_color1   = NVG.rgba(0x00,0xc2,0xea,255)
        text_color2   = NVG.rgba(0x00,0xc2,0xea,255)
        vg.path do |v|
            v.rect(w/8, h/8, w*0.75, h*0.75)
            if(button.value)
                v.fill_color(NVG.rgba(0, 255, 0, 255))
            else
                v.fill_color(off_color)
            end
            v.stroke_color(outline_color)
            v.fill
            v.stroke_width 2
            v.stroke
        end

        vg.font_face("bold")
        vg.font_size h*0.55
        vg.text_align NVG::ALIGN_CENTER | NVG::ALIGN_MIDDLE
        if(value)
            vg.fill_color(text_color1)
        else
            vg.fill_color(text_color2)
        end
        vg.text(w/2,h/2,button.label.upcase)
    }
}
