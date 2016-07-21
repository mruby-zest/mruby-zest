ToggleButton {
    property Bool value: false
    function class_name() {"powbutton"}
    function draw(vg) {
        #Draw background
        grad = if(self.value)
            bright_green = NVG.rgba(0x00,0xAe,0x9c, 255)
            dark_green   = NVG.rgba(0x00,0x73,0x68,0xff)
            vg.linear_gradient(0,0,0,h, bright_green, dark_green)
        else
            grey1 = Theme::ButtonGrad1
            grey2 = Theme::ButtonGrad2
            vg.linear_gradient(0,0,0,h, grey1, grey2)
        end
        vg.stroke_color color("000000", 0xa0)

        grey1 = Theme::ButtonGrad1
        grey2 = Theme::ButtonGrad2
        grad2 = vg.linear_gradient(0,0,0,h, grey1, grey2)
        vg.path do |v|
            pad = 0
            v.rect(pad,0,w,h)
            if(self.value)
                v.fill_paint grad
            else
                v.fill_paint grad2
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
        r      = 0.18*[h,w].min
        super_green = color("72fced")
        vg.line_cap(NVG::SQUARE);
        vg.path do |vg|
            vg.arc(cx, cy, r, center+pi*0.75, center-pi*0.75, 1);
            vg.move_to(cx, 0.45*h);
            vg.line_to(cx, 0.30*h);
            vg.stroke_width(1.0);
            vg.stroke_color(super_green)
            vg.stroke
        end
    }
    function layout(l)
    {
        self_box(l)
    }
}
