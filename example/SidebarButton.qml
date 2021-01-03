Widget {
    id: button
    property Function whenClick: nil
    property Bool value: false
    tooltip: ""

    function onMouseEnter(ev) {
        if(self.tooltip != "")
            self.root.log(:tooltip, self.tooltip)
        end
    }

    function onMousePress(ev) {
        self.value = !self.value
        damage_self
        self.whenClick.call if whenClick
    }

    function draw_button(vg)
    {
        pad = 0
        off_color     = Theme::ButtonInactive
        on_color      = Theme::ButtonActive
        cs = 0
        vg.path do |v|
            v.rounded_rect(w*pad, h*pad, w*(1-2*pad), h*(1-2*pad), 3)
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

        vg.translate(0.5,0.5)

        vg.path do |v|
            hh = h/32
            source_x = 1
            source_y = (hh).round()
            dest_x = (w-2).round()
            dest_y = source_y

            v.move_to(source_x, source_y)
            v.line_to(dest_x, dest_y)

            if(self.value)
                v.stroke_color color("16a39c")
            else
                v.stroke_color color("5c5c5c")
            end

            v.stroke_width 1
            v.stroke
        end

        vg.translate(-0.5,-0.5)
    }

    function draw(vg)
    {
        #h = button.h
        #w = button.w
        ##puts("drawing a button...")
        #bright_green = color("00AE9C")
        #dark_green   = color("007368")
        #grad = vg.linear_gradient(0,0,0,h, bright_green, dark_green)
        #vg.stroke_color(NVG.rgba(0,0,0,0x80))

        #grey1 = Theme::ButtonGrad1
        #grey2 = Theme::ButtonGrad2
        #grad2 = vg.linear_gradient(0,0,0,h, grey1, grey2)
        #vg.path do |v|
        #    v.rounded_rect(0,0,w,h,2)
        #    if(value)
        #        bright_green = color("00AE9C")
        #        dark_green   = color("007368")
        #        grad = vg.linear_gradient(0,0,0,h, bright_green, dark_green)
        #        v.fill_paint grad
        #    else
        #        v.fill_paint grad2
        #    end
        #    v.stroke_width 1
        #    v.fill
        #    v.stroke
        #end
        draw_button(vg)

        text_color1   = color("52FAFE")
        text_color2   = Theme::TextColor
        vg.font_face("bold")
        vg.font_size h*0.55
        vg.text_align NVG::ALIGN_CENTER | NVG::ALIGN_MIDDLE
        if(value)
            vg.fill_color(text_color1)
        else
            vg.fill_color(text_color2)
        end
        vg.text(w/2,h/2,label.upcase)

    }

}
