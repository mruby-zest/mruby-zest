Widget {
    function draw(vg)
    {
        pad  = 1/64
        pad2 = (1-2*pad)
        vg.path do |v|
            v.rect(w*pad, h*pad, w*pad2, h*pad2)
            paint = v.linear_gradient(0,0,0,h,
            Theme::ButtonGrad1, Theme::ButtonGrad2)
            v.fill_paint paint
            v.fill
            v.stroke_width 1
            v.stroke
        end

        vg.path do |v|
            v.move_to(w*1/3, 0)
            v.line_to(w*1/3, h)
            v.move_to(w*2/3, 0)
            v.line_to(w*2/3, h)
            v.stroke
        end

        text_color = Theme::TextColor

        draw_stop(vg, text_color)
        draw_pause( vg, text_color)
        draw_play(  vg, text_color)
    }

    function draw_record(vg, text_color) {
        r = [1/6*w, 1/2*h].min*0.4
        vg.path do |v|
            v.circle(1/6*w, 1/2*h, r)
            v.fill_color text_color
            v.fill
        end
    }

    function draw_stop(vg, text_color) {
        r = [1/6*w, 1/2*h].min*0.4
        vg.path do |v|
            v.rect(1/6*w-r, 1/2*h-r, 2*r, 2*r)
            v.fill_color text_color
            v.fill
        end
    }

    function draw_pause(vg, text_color) {
        vg.path do |v|
            v.rect((3/6-1/18)*w, 0.2*h, 1/24*w, 0.6*h)
            v.rect((3/6+1/18)*w, 0.2*h, 1/24*w, 0.6*h)
            v.fill_color text_color
            v.fill
        end
    }

    function draw_play(vg, text_color) {
        vg.path do |v|
            v.move_to((5/6-1/18)*w, 0.25*h)
            v.line_to((5/6-1/18)*w, 0.75*h)
            v.line_to((5/6+1/18)*w, 0.5*h)
            v.close_path
            v.fill_color text_color
            v.fill
        end
    }

    function onMousePress(ev)
    {
        px = (ev.pos.x-global_x)/w
        if(px > 0.666)
            $remote.action("/HDDRecorder/start")
        elsif(px > 0.333)
            $remote.action("/HDDRecorder/pause")
        else
            $remote.action("/HDDRecorder/stop")
        end

    }
}
