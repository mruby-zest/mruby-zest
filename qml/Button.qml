Widget {
    id: button
    property signal action: nil;
    property Bool   value:    false;
    property String renderer: nil;
    property Float  textScale: 0.75;
    property Function whenValue: nil;
    property Float pad: 1/64

    function onMousePress(ev) {
        puts "Button Press"
        button.value = !button.value
        damage_self
        whenValue.call if whenValue
    }

    function onMouseEnter(ev) {
        if(self.tooltip != "")
            self.root.log(:tooltip, self.tooltip)
        end
    }

    function onMerge(val)
    {
        button.value = val.value if(val.respond_to? :value)
    }

    function class_name()
    {
        "Button"
    }
    function layout(l)
    {
        t = widget.class_name.to_sym
        selfBox = l.genBox t, button
        if(!self.layoutOpts.include?(:no_constraint))
            if(label.length == 1)
                l.aspect(selfBox, 1, 1)
            else
                scale = 100
                $vg.font_size scale
                bb = $vg.text_bounds(0, 0, label.upcase)
                if(bb != 0)
                    #Width cannot be so small that letters overflow
                    l.sh([selfBox.w, selfBox.h], [-1.0, bb/scale], 0)
                end
            end
        else
            #puts "NONONONONONONONONN"
        end
        selfBox
    }

    function draw(vg)
    {
        off_color     = Theme::ButtonInactive
        on_color      = Theme::ButtonActive
        outline_color = color("707070")
        text_color1   = color("52FAFE")
        text_color2   = Theme::TextColor
        vg.path do |v|
            v.rect(w*pad, h*pad, w*(1-2*pad), h*(1-2*pad))
            if(button.value == true)
                v.fill_color on_color
            elsif(button.value.class == Float && button.value != 0)
                t = button.value
                on = on_color
                of = Theme::ButtonGrad1
                v.fill_color(color_rgb(on.r*t + of.r*(1-t),
                                       on.g*t + of.g*(1-t),
                                       on.b*t + of.b*(1-t)))
            else
                paint = v.linear_gradient(0,0,0,h,
                Theme::ButtonGrad1, Theme::ButtonGrad2)
                v.fill_paint paint
            end
            #v.stroke_color(outline_color)
            v.fill
            v.stroke_width 1
            v.stroke
        end

        vg.font_face("bold")
        vg.font_size h*self.textScale
        if(value == true)
            vg.fill_color(text_color1)
        else
            vg.fill_color(text_color2)
        end
        if(layoutOpts.include? :left_text)
            vg.text_align NVG::ALIGN_LEFT | NVG::ALIGN_MIDDLE
            vg.text(8,h/2,button.label.upcase)
        else
            vg.text_align NVG::ALIGN_CENTER | NVG::ALIGN_MIDDLE
            vg.text(w/2,h/2,button.label.upcase)
        end
    }
}
