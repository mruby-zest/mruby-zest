Widget {
    function circ(vg, cx, cy, r, col)
    {
        vg.path do
            #vg.arc(cx, cy, r, 0, 3.14, 1)
            vg.circle(cx, cy, r)
            vg.fill_color col
            vg.fill
        end
    }

    function circ_mag(vg, cx, cy, h, col)
    {
        vg.path do
            vg.rect(cx-5, cy-h, 10, 2*h)
            vg.fill_color col
            vg.fill
        end
    }

    function circ_link(vg, x1, y1, m1, x2, y2, m2, col)
    {
        vg.path do
            vg.move_to(x1+5, y1-m1)
            vg.line_to(x2-5, y2-m2)
            vg.line_to(x2-5, y2+m2)
            vg.line_to(x1+5, y1+m1)
            vg.close_path
            vg.fill
        end
        angle = Math.atan2(y2-y1, x2-x1)
        xdiff = Math.cos(angle)*20
        ydiff = Math.sin(angle)*20
        vg.path do
            vg.move_to(x1+xdiff, y1+ydiff)
            vg.line_to(x2-xdiff, y2-ydiff)
            vg.stroke_color col
            vg.stroke
        end
    }

    function circ_text(vg, bx, by, label)
    {
        vg.text_align NVG::ALIGN_MIDDLE | NVG::ALIGN_CENTER
        vg.font_size 30.0
        vg.fill_color color("ffffff")
        vg.text(bx, by, label)
    }

    function draw(vg)
    {
        draw2(vg)
    }
    function draw1(vg)
    {
        fixedpad = 5
        pad  = 0
        pad2 = (1-2*pad)
        box = Rect.new(w*pad  + fixedpad,   h*pad  + fixedpad,
                       w*pad2 - 2*fixedpad, h*pad2 - 2*fixedpad)
        vg.path do
            vg.rect(box.x, box.y, box.w, box.h)
            vg.fill_color Theme::VisualBackground
            vg.fill
        end
        Draw::Grid::linear_x(vg, 1, 10, box)
        vg.stroke_width 1.5
        Draw::Grid::log_y(vg, 1, 10000, box)

        radius = 20

        bx1 = box.x + 0.1*box.w
        by1 = box.y + 0.2*box.h
        m1  = 40

        bx2 = box.x+0.5*box.w
        by2 = box.y+0.4*box.h
        m2  = 60
        
        bx3 = box.x+0.9*box.w
        by3 = box.y+0.3*box.h
        m3  = 20

        green = color("00ff00", 100)
        lab   = "1"

        circ(vg, bx1, by1, radius, green)
        circ(vg, bx2, by2, radius, green)
        circ(vg, bx3, by3, radius, green)

        circ_mag(vg, bx1, by1, m1, green)
        circ_mag(vg, bx2, by2, m2, green)
        circ_mag(vg, bx3, by3, m3, green)

        circ_link(vg, bx1, by1, m1, bx2, by2, m2, green)
        circ_link(vg, bx2, by2, m2, bx3, by3, m3, green)
        circ_text(vg, bx1, by1, lab)
        circ_text(vg, bx2, by2, lab)
        circ_text(vg, bx3, by3, lab)
        
        green = color("00ffff", 100)
        lab   = "2"
        #bx1 = box.x + 0.2*box.w
        by1 = box.y + 0.9*box.h
        m1  = 10

        #bx2 = box.x+0.4*box.w
        by2 = box.y+0.8*box.h
        m2  = 100
        
        #bx3 = box.x+0.6*box.w
        by3 = box.y+0.8*box.h
        m3  = 90
        
        circ(vg, bx1, by1, radius, green)
        circ(vg, bx2, by2, radius, green)
        circ(vg, bx3, by3, radius, green)

        circ_mag(vg, bx1, by1, m1, green)
        circ_mag(vg, bx2, by2, m2, green)
        circ_mag(vg, bx3, by3, m3, green)

        circ_link(vg, bx1, by1, m1, bx2, by2, m2, green)
        circ_link(vg, bx2, by2, m2, bx3, by3, m3, green)
        circ_text(vg, bx1, by1, lab)
        circ_text(vg, bx2, by2, lab)
        circ_text(vg, bx3, by3, lab)
        
        
        green = color("ffff00", 100)
        lab   = "3"
        #bx1 = box.x + 0.2*box.w
        by1 = box.y + 0.4*box.h
        m1  = 10

        #bx2 = box.x+0.4*box.w
        by2 = box.y+0.5*box.h
        m2  = 2
        
        #bx3 = box.x+0.6*box.w
        by3 = box.y+0.6*box.h
        m3  = 25
        
        circ(vg, bx1, by1, radius, green)
        circ(vg, bx2, by2, radius, green)
        circ(vg, bx3, by3, radius, green)

        circ_mag(vg, bx1, by1, m1, green)
        circ_mag(vg, bx2, by2, m2, green)
        circ_mag(vg, bx3, by3, m3, green)

        circ_link(vg, bx1, by1, m1, bx2, by2, m2, green)
        circ_link(vg, bx2, by2, m2, bx3, by3, m3, green)
        circ_text(vg, bx1, by1, lab)
        circ_text(vg, bx2, by2, lab)
        circ_text(vg, bx3, by3, lab)
        
        lab   = "4"
        green = color("ff0000", 100)
        #bx1 = box.x + 0.2*box.w
        by1 = box.y + 0.1*box.h
        m1  = 10

        #bx2 = box.x+0.4*box.w
        by2 = box.y+0.15*box.h
        m2  = 35
        
        #bx3 = box.x+0.6*box.w
        by3 = box.y+0.6*box.h
        m3  = 25
        
        circ(vg, bx1, by1, radius, green)
        circ(vg, bx2, by2, radius, green)
        #circ(vg, bx3, by3, radius, green)

        circ_mag(vg, bx1, by1, m1, green)
        circ_mag(vg, bx2, by2, m2, green)
        #circ_mag(vg, bx3, by3, m3, green)

        circ_link(vg, bx1, by1, m1, bx2, by2, m2, green)
        #circ_link(vg, bx2, by2, m2, bx3, by3, m3, green)
        circ_text(vg, bx1, by1, lab)
        circ_text(vg, bx2, by2, lab)
        #circ_text(vg, bx3, by3, lab)

    }

    function circ_filter(vg, bx, by, br, lab, col, box)
    {
        circ(vg, bx, by, br, col)

        delta = (box.h-by)/2.0
        bot_left = [bx-delta-br, box.h]
        bot_right = [bx+delta+br, box.h]

        #vg.path do
        #    vg.move_to(bx-br, by)
        #    vg.line_to(bot_left[0], bot_left[1])
        #    vg.line_to(bot_right[0], bot_right[1])
        #    vg.line_to(bx+br, by)
        #    vg.fill_color(col)
        #    vg.fill
        #end
        
        circ_text(vg, bx, by, lab)
    }

    function draw2(vg)
    {
        fixedpad = 5
        pad  = 0
        pad2 = (1-2*pad)
        box = Rect.new(w*pad  + fixedpad,   h*pad  + fixedpad,
                       w*pad2 - 2*fixedpad, h*pad2 - 2*fixedpad)
        vg.path do
            vg.rect(box.x, box.y, box.w, box.h)
            vg.fill_color Theme::VisualBackground
            vg.fill
        end
        Draw::Grid::log_x(vg, 1, 10000, box)
        vg.stroke_width 1.5
        Draw::Grid::linear_y(vg, 1, 50, box)

        radius = 10
        green = color("00ff00", 100)
        lab   = "1"
        bx1 = box.x + 0.1*box.w
        by1 = box.y + 0.8*box.h

        circ_filter(vg, bx1, by1, radius, lab, green, box)

        radius = 30
        green = color("00ffff", 100)
        lab   = "2"
        bx1 = box.x + 0.2*box.w
        by1 = box.y + 0.75*box.h
        
        circ_filter(vg, bx1, by1, radius, lab, green, box)

        radius = 20
        green = color("ffff00", 100)
        lab   = "3"
        bx1 = box.x + 0.6*box.w
        by1 = box.y + 0.2*box.h

        circ_filter(vg, bx1, by1, radius, lab, green, box)

        radius = 90
        green = color("ff0000", 100)
        lab   = "4"
        bx1 = box.x + 0.8*box.w
        by1 = box.y + 0.4*box.h

        circ_filter(vg, bx1, by1, radius, lab, green, box)
    }
}
