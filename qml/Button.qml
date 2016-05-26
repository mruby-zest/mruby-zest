Widget {
    id: button
    property signal action: nil;
    property String extern:   "";
    property Bool   value:    false;
    property String renderer: nil;
    property Float  textScale: 0.75;
    
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
        selfBox = l.genBox t, button
        if(!button.layoutOpts.include?(:no_constraint))
            scale = 100
            $vg.font_size scale
            bb = $vg.text_bounds(0, 0, label.upcase)
            if(bb != 0)
                #Width cannot be so small that letters overflow
                l.sh([selfBox.w, selfBox.h], [-1.0, bb/scale], 0)
            end
        else
            #puts "NONONONONONONONONN"
        end
        selfBox
    }

    function draw(vg)
    {
        off_color     = color("424B56")
        outline_color = color("707070")
        text_color1   = color("52FAFE")
        text_color2   = color("B9CADE")
        pad = 1/64
        vg.path do |v|
            v.rect(w*pad, h*pad, w*(1-2*pad), h*(1-2*pad))
            if(button.value)
                v.fill_color(NVG.rgba(0, 255, 0, 255))
            else
                v.fill_color(off_color)
            end
            #v.stroke_color(outline_color)
            v.fill
            v.stroke_width 1
            v.stroke
        end

        vg.font_face("bold")
        vg.font_size h*self.textScale
        vg.text_align NVG::ALIGN_CENTER | NVG::ALIGN_MIDDLE
        if(value)
            vg.fill_color(text_color1)
        else
            vg.fill_color(text_color2)
        end
        vg.text(w/2,h/2,button.label.upcase)
    }
}
