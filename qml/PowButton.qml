Widget {
    function draw(vg) {
        pi     = 3.141592653
        cx     = x+w/2.0;
        cy     = y+h/2.0;
        center = -pi/2.0;
        sw     = [h,w].min/15.0;
        r      = 0.18*[h,w].min
        super_green = NVG.rgba(0x72,0xfc,0xed, 255)
        vg.line_cap(NVG::SQUARE);
        vg.stroke_width(sw);
        vg.stroke_color(super_green)
        vg.path do |vg|
            vg.arc(cx, cy, r, center-0.5, center+0.5, 1);
            vg.move_to(cx, y+0.45*h);
            vg.line_to(cx, y+0.30*h);
            vg.stroke
        end
    }
}
