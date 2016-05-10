Widget {
    id: test
    function draw(vg)
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
            v.fill_color(NVG.rgba(0x11,0x45,0x75,255));
            v.fill
        end

        len = (3.0/2.0*pi)*0.5;
        startt = end_ + len;

        vg.path do |v|
            v.arc(cx, cy, inner, end_, startt, 2);
            v.arc(cx, cy, outer, startt, end_, 1);
            v.close_path
            v.fill_color(NVG.rgba(0x3a,0xc5,0xec,255));
            v.fill
        end
    }
    
    function onMousePress(ev) {
        puts "I got a mouse press (overlaytest)"
        puts test.root
        if(children.empty?)
            widget = OverlayBox.new(test.db)
            widget.w = test.w
            widget.h = test.h
            widget.x = 0
            widget.y = 0
            Qml::add_child(test, widget)
            test.root.smash_draw_seq
        end
        test.root.damage_item(test)
    }

}
