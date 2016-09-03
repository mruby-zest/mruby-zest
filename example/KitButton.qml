Widget {
    id: button
    property signal action: nil;
    property String extern:   "";
    property Bool   value:    false;
    property String renderer: nil;
    property Bool   enable:   false

    function set_enable(v) {
        if(button.enable != v)
            button.enable = v
            damage_self
        end
    }

    function onMousePress(ev) {
        action.call if action
        damage_self
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
        off_color     = Theme::ButtonInactive
        on_color      = Theme::ButtonActive
        outline_color = color("0089b9")
        text_color1   = Theme::TextActiveColor
        text_color2   = color("B9CADE")
        #TODO check textcolor2 and outline
        pad = 1/32
        vg.path do |v|
            v.rect(w*pad, h*pad, w*(1-2*pad), h*(1-2*pad))
            if(button.value)
                v.fill_color on_color
            else
                v.fill_color off_color
            end
            v.fill
            if(self.enable)
                v.stroke_color(outline_color)
                v.stroke_width 1
                v.stroke
            end
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
