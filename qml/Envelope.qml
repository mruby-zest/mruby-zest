Widget {
    function class_name()
    {
        "Envelope"
    }

    function draw(vg)
    {
        vg.path do |v|
            v.rect(0,0,w,h)
            v.fill_color(NVG.rgba(128, 128, 128, 255))
            v.fill
        end
        #      0         1         2         3         4
        dat = [0.0, 0.0, 0.5, 0.2, 0.3, 0.7,-0.9, 0.8, 0.0, 1.0];
        fill_color   = NVG.rgba(0x0d, 0x0d, 0x0d,255)
        stroke_color = NVG.rgba(0x01, 0x47, 0x67,255)

        light_fill   = NVG.rgba(0x11,0x45,0x75,55)
        bright       = NVG.rgba(0x3a,0xc5,0xec,255)

        dim          =  NVG.rgba(0x11,0x45,0x75,255)

        vg.path do |v|
            v.rect(0,0,w,h)
            v.fill_color   fill_color
            v.stroke_color stroke_color
            v.fill
            v.stroke
        end

        #puts("draw underline")
        ##Draw UnderLine
        ###Bottom Half
        vg.scissor(0, h/2, w, h/2)
        vg.path do |vg|
            vg.move_to(0.0, 0.0);
            (0...(dat.length/2)).each do |i|
                vg.line_to(w*dat[2*i+1], h/2-h/2*dat[2*i]);
            end
            vg.line_to(w, 0.0)
            vg.close_path
            vg.fill_color light_fill
            vg.fill
        end
        vg.reset_scissor

        #////Upper Half
        vg.scissor(0, 0, w, h/2);
        vg.path do |vg|
            vg.move_to(w,h)
            (0...(dat.length/2)).each do |i|
                vg.line_to(w*dat[2*i+1], h/2-h/2*dat[2*i]);
            end
            vg.line_to(w,h)
            vg.close_path
            vg.fill_color light_fill
            vg.fill
        end
        vg.reset_scissor

        #//Draw Zero Line
        vg.path do |vg|
            vg.move_to(0, h/2)
            vg.line_to(w, h/2)
            vg.stroke_color dim
            vg.stroke
        end

        n = dat.length
        m = 2
        #Draw Sel Line
        if(m >= 0 && m < n)
            vg.path do |v|
                v.move_to(w*dat[2*m+1], 0)
                v.line_to(w*dat[2*m+1], h)
            end
            vg.stroke_color(dim);
            vg.stroke
        end

        #Draw Actual Line
        vg.path do |vg|
            vg.move_to(w*dat[1],h/2-h/2*dat[0])
            (0...(dat.length/2)).each do |i|
                vg.line_to(w*dat[2*i+1], h/2-h/2*dat[2*i]);
            end
            vg.stroke_width 3.0
            vg.stroke_color bright
            vg.stroke
        end
        vg.stroke_width 1.0

        (0...(dat.length/2)).each do |i|
            xx = w*dat[2*i+1];
            yy = h/2-h/2*dat[2*i];
            scale = h/80
            vg.path do |vg|
                vg.rect(xx-scale,yy-scale,scale*2,scale*2);
                vg.fill_color NVG.rgba(0,0,0,255)
                vg.stroke_color bright
                vg.stroke_width scale*0.5
                vg.fill
                vg.stroke
            end
        end
    }
}
