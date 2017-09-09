def min(a,b)
    if(a<b)
        a
    else
        b
    end
end
#hue -1..1
def draw_color_wheel(vg, x, y, w, h, hue)
    vg.save()

    cx = x + w/2
    cy = y + h/2

    r1 = min(w,h)/2 - 5
    r0 = r1 - 20

    aeps = 0.5 / r1;	# half a pixel arc length in radians (2pi cancels out).

    (0...6).each do |i|
        a0 = i / 6 * Math::PI * 2 - aeps;
        a1 = (i+1) / 6 * Math::PI * 2 + aeps;
        vg.path do
            vg.arc(cx,cy, r0, a0, a1, NVG::CW);
            vg.arc(cx,cy, r1, a1, a0, NVG::CCW);
        end
        ax = cx + Math::cos(a0) * (r0+r1)*0.5
        ay = cy + Math::sin(a0) * (r0+r1)*0.5
        bx = cx + Math::cos(a1) * (r0+r1)*0.5
        by = cy + Math::sin(a1) * (r0+r1)*0.5
        paint = vg.linear_gradient(ax,ay, bx,by, 
                                   NVG::Color::hsla(a0/(Math::PI*2),1.0,0.55,255),
                                   NVG::Color::hsla(a1/(Math::PI*2),1.0,0.55,255));
        vg.fill_paint(paint)
        vg.fill
    end

    vg.path do
        vg.circle(cx, cy, r0 - 0.5)
        vg.circle(cx, cy, r0 + 0.5)
        vg.stroke_color color("000000",64)
        vg.stroke_width 1.0
        vg.stroke
    end

    # Selector
    vg.save
    vg.translate(cx, cy)
    vg.rotate(hue*Math::PI*2)

    # Marker on
    vg.path do
        vg.rect(r0-1,-3,r1-r0+2,6)
        vg.stroke_color color("ffffff", 192)
        vg.stroke_width 2.0
        vg.stroke
    end

    paint = vg.box_gradient(r0-3,-5,r1-r0+6,10, 2,4,
                            color("000000", 128),
                            color("000000", 0))
    vg.path do
        vg.rect(r0-2-10,-4-10,r1-r0+4+20,8+20);
        vg.rect(r0-2,-4,r1-r0+4,8);
        vg.path_winding NVG::HOLE
        vg.fill_paint paint
        vg.fill
    end

    # Center triangle
    r = r0 - 6;
    ax = Math::cos( 120.0/180.0*Math::PI) * r;
    ay = Math::sin( 120.0/180.0*Math::PI) * r;
    bx = Math::cos(-120.0/180.0*Math::PI) * r;
    by = Math::sin(-120.0/180.0*Math::PI) * r;
    vg.path do
        vg.move_to(r,  0)
        vg.line_to(ax, ay)
        vg.line_to(bx, by)
        vg.close_path

        paint = vg.linear_gradient(r,0, ax,ay, NVG::Color::hsla(hue,1.0,0.5,255),
                                               NVG::Color::hsla(255,255,255,255));
        vg.fill_paint paint
        vg.fill
        paint = vg.linear_gradient((r+ax)/2,(0+ay)/2, bx,by,
                                   color("000000",0),
                                   color("000000",255))
        vg.fill_paint paint
        vg.fill
        vg.stroke_color color("000000", 64)
        vg.stroke
    end

    # Select circle on triangle
    ax = Math::cos(120.0/180.0*Math::PI) * r*0.3
    ay = Math::sin(120.0/180.0*Math::PI) * r*0.4
    vg.path do
        vg.circle(ax, ay, 5)
        vg.stroke_color(color("ffffff", 192))
        vg.stroke_width 2.0
        vg.stroke
    end

    paint = vg.radial_gradient(ax,ay, 7,9, color("000000", 64), color("000000", 0))
    vg.path do
        vg.rect(ax-20, ay-20, 40, 40)
        vg.circle(ax, ay, 7)
        vg.path_winding NVG::HOLE
        vg.fill_paint paint
        vg.fill
    end

    vg.restore
    vg.restore
end
