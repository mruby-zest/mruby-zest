Widget {
    id: button
    property signal   action: nil;
    property Bool     value:    false;
    property String   renderer: nil;
    property Float    textScale: 0.75;
    property Function whenValue: nil;
    property Float    pad: 1.0/64
    property Bool     active: true

    function onMousePress(ev) {
        return if !self.active
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

    function aspect2(box, ww, hh)
    {
        provided    = box.w/box.h
        recommended = ww/hh
        if(recommended > provided)
            #Decrease height
            new_height = box.h*provided/recommended
            box.y += (box.h-new_height)/2
            box.h = new_height
        else
            new_width = box.w*recommended/provided
            box.x += (box.w-new_width)/2
            box.w  = new_width
        end
    }


    function layout(l, selfBox)
    {
        if(!self.layoutOpts.include?(:no_constraint))
            if(label.length == 1)
                l.aspect(selfBox, 1, 1)
            else
                scale = 100
                $vg.font_size scale
                bb = $vg.text_bounds(0, 0, label.upcase)
                if(bb != 0)
                    #Width cannot be so small that letters overflow
                    self.aspect2(selfBox, bb, scale)
                end
            end
        end
        selfBox
    }

    function draw_text(vg)
    {
        text_color1   = Theme::TextActiveColor
        text_color2   = Theme::TextColor
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

    function draw_inactive(vg)
    {
        strike_color = Theme::TextColor
        vg.path do
            vg.move_to(w*pad, h*pad)
            vg.line_to(w*(1-2*pad), h*(1-2*pad))
            vg.stroke_width 1.0
            vg.stroke_color strike_color
            vg.stroke
        end
    }

    function draw_button(vg)
    {
        off_color     = Theme::ButtonInactive
        on_color      = Theme::ButtonActive
        cs = 0
        vg.path do |v|
            v.rounded_rect(w*pad, h*pad, w*(1-2*pad), h*(1-2*pad), 2)
            if(button.value == true)
                cs = 1
                v.fill_color on_color
            elsif(button.value.class == Float && button.value != 0)
                cs = 2
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
            v.fill
            v.stroke_width 1
            v.stroke

        end

        vg.path do |v|
            hh = h/20
            v.move_to(w*pad+1,       h*pad+hh)
            v.line_to(w*(1-2*pad)+1, h*pad+hh)
            if(cs == 0)
                v.stroke_color color("5c5c5c")
            elsif(cs == 1)
                v.stroke_color color("16a39c")
            end
            if([0,1].include?(cs))
                v.stroke_width hh
                v.stroke
            end
        end
    }


    function draw(vg)
    {
        draw_button(vg)

        draw_text(vg)

        draw_inactive(vg) if !self.active
    }
}
