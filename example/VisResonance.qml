Widget {
    property Int prev: nil
    function draw(vg)
    {
        vg.path do |v|
            v.rect(0,0,w,h)
            v.fill_color   Theme::VisualBackground
            v.fill
        end

        pad = 5
        bb  = Rect.new(pad,pad,w-2*pad,h-2*pad)
        Draw::Grid::linear_x(vg, 0, 10, bb)
        Draw::Grid::linear_y(vg, 0, 10, bb)
    }

    function runUpdate(pos, type)
    {
        rely  = 1 - 2*(pos.y - global_y) / h
        relx  = (pos.x - global_x) / w
        return if(relx < 0 || relx > 1)
        rely  = [1, [-1, rely].max].min

        n = draw_layer.points.length
        sel = (n*relx).to_i
        draw_layer.points[sel] = rely

        #Check to see if interpolation is needed
        if(type == :move && ![prev-1, prev, prev+1].include?(sel))
            srt = [sel,prev].min
            dst = [sel,prev].max
            a   = draw_layer.points[srt]
            b   = draw_layer.points[dst]
            (srt...dst).each do |i|
                ri = (i-srt)/(dst-srt)
                draw_layer.points[i] = a+ri*(b-a)
            end
        end
        self.prev = sel
        draw_layer.damage_self
    }


    function onMousePress(ev)
    {
        runUpdate(ev.pos, :press)
    }

    function onMouseMove(ev)
    {
        runUpdate(ev.pos, :move)
    }

    DataViewAlt {
        id: draw_layer
    }
}
