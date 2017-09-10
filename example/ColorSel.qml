Widget {
    function draw(vg) {
        @hue ||= 0.2
        @sx  ||= 0.1
        @sy  ||= 0.4
        draw_color_wheel(vg, x, y, w, h,
            @hue / (2*Math::PI), @sx, @sy)
    }

    function abs(x) { [x,-x].max }

    function onMousePress(ev) {
        cx = x + w/2
        cy = y + h/2

        r1 = min(w,h)/2 - 5
        r0 = r1 - 20

        xx = ev.pos.x-global_x
        yy = ev.pos.y-global_y

        dx = (xx-cx)
        dy = (yy-cy)

        rr = Math::sqrt(dx*dx + dy*dy)

        #puts "#{r1} -- #{rr} -- #{r0}"

        if(r0 < rr && rr < r1)
            @hue = Math::atan2(dy,dx)
            #puts @hue
            damage_self
        end

        rt = r0 - 6

        tri_upper_x     = cx + rt*Math::cos(@hue)
        tri_upper_y     = cy + rt*Math::sin(@hue)

        tri_low_left_x  = cx + rt*Math::cos(@hue - (2*Math::PI)/3)
        tri_low_left_y  = cy + rt*Math::sin(@hue - (2*Math::PI)/3)

        tri_low_right_x = cx + rt*Math::cos(@hue + (2*Math::PI)/3)
        tri_low_right_y = cy + rt*Math::sin(@hue + (2*Math::PI)/3)

        _ux = tri_upper_x
        _uy = tri_upper_y
        _lx = tri_low_left_x
        _ly = tri_low_left_y
        _rx = tri_low_right_x
        _ry = tri_low_right_y

        _bx = (_lx+_rx)/2
        _by = (_ly+_ry)/2

        ul = dist(xx, yy, _ux, _uy, _lx, _ly)
        ur = dist(xx, yy, _rx, _ry, _ux, _uy)
        bt = dist(xx, yy, _lx, _ly, _rx, _ry)
        md = dist(xx, yy, _ux, _uy, _bx, _by)

        #puts "%%%  #{ul} -- #{ur} -- #{bt}"
        #puts "inside" if ul > 0 && ur > 0 && bt > 0

        range_y = Math::sqrt((_bx-_ux)*(_bx-_ux)+(_by-_uy)*(_by-_uy))
        range_x = Math::sqrt((_lx-_rx)*(_lx-_rx)+(_ly-_ry)*(_ly-_ry))/2



        #puts "y = #{bt/range_y} x = #{md/range_x}"
        if(ul > 0 && ur > 0 && bt > 0)
            #Yes, this is intentionally reversed
            @sy = md/range_x

            @sx = bt/range_y
            extra = Math::sin(Math::PI/6.0)
            @sx = @sx*(1+extra) - extra
            #puts "@sx=#{@sx}  @sy=#{@sy}"
            damage_self
        end
    }

    function dist(px, py, x1, y1, x2, y2)
    {
        ((y2-y1)*px - (x2-x1)*py + x2*y1 - y2*x1)/Math::sqrt((y2-y1)*(y2-y1) + (x2-x1)*(x2-x1))
    }
    
    function onMouseMove(ev) {
        onMousePress(ev)
    }
}
