Widget {
    id: button
    property Function whenClick: nil
    property Bool value: false

    function onMousePress(ev) {
        self.value = !self.value
        damage_self
        self.whenClick.call if whenClick
    }

    function draw(vg)
    {
        h = button.h
        w = button.w
        #puts("drawing a button...")
        bright_green = color("00AE9C")
        dark_green   = color("007368")
        grad = vg.linear_gradient(0,0,0,h, bright_green, dark_green)
        vg.stroke_color(NVG.rgba(0,0,0,0x80))

        grey1 = Theme::ButtonGrad1
        grey2 = Theme::ButtonGrad2
        grad2 = vg.linear_gradient(0,0,0,h, grey1, grey2)
        vg.path do |v|
            v.rect(0,0,w,h)
            if(value)
                bright_green = color("00AE9C")
                dark_green   = color("007368")
                grad = vg.linear_gradient(0,0,0,h, bright_green, dark_green)
                v.fill_paint grad
            else
                v.fill_paint grad2
            end
            v.stroke_width 1
            v.fill
            v.stroke
        end

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
