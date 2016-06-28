Widget {
    function class_name() {"powbutton"}
    function draw(vg) {
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
}
