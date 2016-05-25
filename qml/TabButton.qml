Widget {
    id: button
    property Function whenClick:     nil
    property Symbol   highlight_pos: :bottom
    property Bool      value:    false;
    
    function onMousePress(ev) {
        puts "Button Press"
        button.value = !button.value
        if(root)
            root.damage_item self
        end
    }

    function draw(vg)
    {
        bg_color      = color("424B56")
        bg_on_color   = NVG.rgba(0x00,0x81,0x8E,255)
        off_color     = NVG.rgba(0x04,0x37,0x5e,255)
        outline_color = NVG.rgba(0x00,0x00,0x00,255)
        text_color1   = color("52FAFE")
        text_color2   = color("B9CADE")
        vg.path do |v|
            v.rect(0, 0, w, h)
            v.fill_color(bg_color)
            v.fill_color(bg_on_color) if button.value
            v.fill
        end
        vg.path do |v|
            v.move_to(0,0)
            v.line_to(0,h)
            v.move_to(w,0)
            v.line_to(w,h)
            v.stroke_color(outline_color)
            v.stroke_width 1
            v.stroke
        end

        if(button.value)
            pos = 0 
            if(button.highlight_pos == :bottom)
                pos = h*7/8
            end
            vg.path do |v|
                v.rect(0,pos,w,h/8)
                v.fill_color(text_color1)
                v.fill
            end
        end


        vg.font_face("bold")
        vg.font_size h*0.65
        vg.text_align NVG::ALIGN_CENTER | NVG::ALIGN_MIDDLE
        if(button.value)
            vg.fill_color(text_color1)
        else
            vg.fill_color(text_color2)
        end
        vg.text(w/2,h/2,button.label.upcase)
    }

    function layout(l)
    {
        t = widget.class_name.to_sym
        #scale = 100
        #$vg.font_size scale
        #bb = $vg.text_bounds(0, 0, label.upcase)
        selfBox = l.genBox t, button
        #if(bb != 0)
        #    #Width cannot be so small that letters overflow
        #    l.sh([selfBox.w, selfBox.h], [-1.0, 0.7*bb/scale], 0)
        #end
        selfBox
    }
}
