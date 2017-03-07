Valuator {
    id: knob

    function draw_classic(vg)
    {
        pi = 3.14159
        start = pi/4;
        end_   = pi*3.0/4.0;
        inner  = 0.2*[h,w].min
        outer = 0.4*[h,w].min
        cy = h/2;
        cx = w/2;
        kr = h/4;
        vg.path do |v|
            v.arc(cx, cy, outer, start, end_, 1);
            v.arc(cx, cy, inner, end_, start, 2);
            v.close_path
            v.fill_color color("114575")
            v.fill
        end

        len = (3.0/2.0*pi)*knob.value;
        startt = end_ + len;

        vg.path do |v|
            v.arc(cx, cy, inner, end_, startt, 2);
            v.arc(cx, cy, outer, startt, end_, 1);
            v.close_path
            v.fill_color color("3AC5EC")
            v.fill
        end
    }
    
    function strike_through(vg)
    {
        strike_color = Theme::TextColor
        vg.path do
            vg.move_to(w*0, h*0)
            vg.line_to(w*(1-2*0), h*(1-2*0))
            vg.stroke_width 1.0
            vg.stroke_color strike_color
            vg.stroke
        end
    }

    function draw(vg)
    {
        #background color("123456")
        pi = 3.14159
        start = pi/4;
        end_   = pi*3.0/4.0;
        radius  = 0.25*[h*1.0,w].min
        inner  = 0.35*[h*1.0,w].min
        outer = 0.48*[h*1.0,w].min

        #lowest point is 0.707 cy-outer*0.707
        #shift by 0.293/2 to compinsate
        cy = h/2 + h*0.293/4;
        cx = w/2;
        kr = h/4;
        vg.path do |v|
            v.arc(cx, cy, outer, start, end_, 1);
            v.arc(cx, cy, inner, end_, start, 2);
            v.close_path
            v.fill_color color("114575")
            v.fill
        end

        len = (3.0/2.0*pi)*knob.value;
        startt = end_ + len;

        vg.path do |v|
            v.arc(cx, cy, inner, end_, startt, 2);
            v.arc(cx, cy, outer, startt, end_, 1);
            v.close_path
            v.fill_color color("3AC5EC")
            v.fill
            v.stroke
        end

        knob_dash = color("E7E5E2")

        vg.path do |v|
            v.circle(cx, cy, radius)
            paint = v.linear_gradient(0,0,0,h,
            Theme::KnobGrad1, Theme::KnobGrad2)
            v.fill_paint paint
            v.fill
            v.stroke
        end

        vg.path do |v|
            angle = 3*pi/4+3*pi/2*knob.value
            v.move_to(cx, cy)
            v.line_to(cx+radius*Math.cos(angle), cy+radius*Math.sin(angle))
            v.stroke_color knob_dash
            v.stroke_width 0.2*radius
            v.stroke
        end
        
        strike_through(vg) if !self.active
        
    }

    function class_name()
    {
        "Knob"
    }

    function layout(l, selfBox)
    {
        l.aspect(selfBox, 0.9, 1)
        selfBox
    }
}
