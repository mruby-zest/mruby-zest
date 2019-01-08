ToggleButton {
    function class_name() {"powbutton"}
    function draw(vg) {
        #Draw background
        on_color      = Theme::ButtonActive

        vg.stroke_color color("000000", 0xa0)

        vg.path do |v|
            pad = 0
            v.rounded_rect(pad,0,w,h,1)
            if(self.value)
                v.fill_color on_color
            else
                paint = v.linear_gradient(0,0,0,h,
                Theme::ButtonGrad1, Theme::ButtonGrad2)
                v.fill_paint paint
            end
            v.fill
            v.stroke
        end

        #Draw power button
        pi     = 3.141592653
        cx     = w/2.0;
        cy     = h/2.0;
        center = pi/2.0;
        sw     = [h,w].min/15.0;
        r      = 0.195*[h,w].min

        if(self.value)
            power_sign_stroke_color = Theme::TextActiveColor
        else
            power_sign_stroke_color = Theme::TextColor
        end

        vg.line_cap(NVG::SQUARE);
        vg.path do |vg|
            vg.arc(cx, cy, r, center+pi*0.775, center-pi*0.775, 1);
            vg.move_to(cx, 0.42*h);
            vg.line_to(cx, 0.28*h);
            vg.stroke_width(w/12.0);
            vg.stroke_color(power_sign_stroke_color)
            vg.stroke
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

    function layout(l, selfBox)
    {
        l.aspect(selfBox, 1, 1)
        selfBox
    }
}
