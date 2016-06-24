Widget {
    id: button
    property Function whenClick:     nil
    property Symbol   highlight_pos: :bottom
    property Bool     value:    false;

    function onMerge(val)
    {
        button.value = val.value if(val.respond_to?(:value))
    }

    function onMousePress(ev) {
        puts "Button Press"
        button.value = !button.value
        if(root)
            root.damage_item self
        end
        if(self.whenClick)
            self.whenClick.call
        end
    }

    function draw(vg)
    {
        bg_color      = color("424B56")
        bg_on_color   = color("00818E")
        outline_color = NVG.rgba(0x00,0x00,0x00,255)
        dark_off      = color("325A6E")
        text_color1   = color("52FAFE")
        text_color2   = Theme::TextColor
        vg.path do |v|
            v.rect(0, 0, w, h)
            if(button.value)
                v.fill_color(bg_on_color)
            else
                paint = v.linear_gradient(0,0,0,h,Theme::ButtonGrad1, Theme::ButtonGrad2)
                v.fill_paint paint
            end
            v.fill
        end
        vg.path do |v|
            v.rect(0,0,w,h)
            v.stroke_color(outline_color)
            v.stroke_width 1
            v.stroke
        end

        begin
            pos = 0
            if(button.highlight_pos == :bottom)
                pos = h*7/8
            end
            vg.path do |v|
                v.rect(0,pos,w,h/8)
                v.fill_color(text_color1) if  button.value
                v.fill_color(dark_off)    if !button.value
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
        selfBox = l.genBox t, button
        selfBox
    }
}
