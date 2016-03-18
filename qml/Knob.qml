Valuator {
    id: knob
    function draw(vg)
    {
        pi = 3.14159
        start = pi/4;
        end_   = pi*3.0/4.0;
        w = knob.w
        h = knob.h
        inner  = 0.2*[h,w].min
        outer = 0.4*[h,w].min
        cy = h/2;
        cx = w/2;
        kr = h/4;
        vg.path do |v|
            v.arc(cx, cy, outer, start, end_, 1);
            v.arc(cx, cy, inner, end_, start, 2);
            v.close_path
            v.fill_color(NVG.rgba(0x11,0x45,0x75,255));
            v.fill
        end

        len = (3.0/2.0*pi)*knob.value;
        startt = end_ + len;

        vg.path do |v|
            v.arc(cx, cy, inner, end_, startt, 2);
            v.arc(cx, cy, outer, startt, end_, 1);
            v.close_path
            v.fill_color(NVG.rgba(0x3a,0xc5,0xec,255));
            v.fill
        end
    }

    function class_name()
    {
        "Knob"
    }

    function layout(l)
    {
        t = widget.class_name.to_sym
        selfBox = l.genBox t, widget
        l.aspect(selfBox, 1, 1)
        selfBox
    }
}
