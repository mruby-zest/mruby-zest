Widget {
    id: lfo_vis

    property Array points: []

    function onSetup(old=nil)
    {
        p = lfo_vis.points
        # root point
        p << 0
        p << 0
        # sine points
        resolution = 64
        (0..resolution).each do |i|
            x = 0.2+0.8*i/resolution
            y = Math.sin(2*3.14*i/resolution)
            p << y
            p << x
        end
        lfo_vis.points = p
        puts lfo_vis.root
    }

    function draw_grid(vg, r, c, x, w)
    {
        light_fill   = NVG.rgba(0x11,0x45,0x75,100)

        h = lfo_vis.h

        (1..r).each do |ln|
             vg.path do |v|
                 off = (ln/r)*(h/2)
                 vg.move_to(x, h/2+off);
                 vg.line_to(x+w, h/2+off)
                 vg.move_to(x, h/2-off);
                 vg.line_to(x+w, h/2-off)
                 v.stroke_color light_fill
                 v.stroke
             end
         end
         
         (1..c).each do |ln|
             vg.path do |v|
                 off = (ln/c)*(w)
                 vg.move_to(x+off, 0)
                 vg.line_to(x+off, h)
                 v.stroke_color light_fill
                 v.stroke
             end
         end
    }

    function draw(vg)
    {
        vg.path do |v|
            v.rect(0,0,w,h)
            v.fill_color(NVG.rgba(128, 128, 128, 255))
            v.fill
        end

        dat = lfo_vis.points
        if(dat.empty?)
            puts "um, it's empty..."
            return
        end

        fill_color   = NVG.rgba(0x0d, 0x0d, 0x0d,255)
        stroke_color = NVG.rgba(0x01, 0x47, 0x67,255)

        light_fill   = NVG.rgba(0x11,0x45,0x75,55)
        light_filll   = NVG.rgba(0x91,0x15,0x15,15)
        bright       = NVG.rgba(0x3a,0xc5,0xec,255)

        dim          = NVG.rgba(0x11,0x45,0x75,255)

        sel_color    = NVG.rgba(0x00, 0xff, 0x00, 255)

        vg.path do |v|
            v.rect(0,0,w,h)
            v.fill_color   fill_color
            v.stroke_color stroke_color
            v.fill
            v.stroke
        end

        draw_grid(vg, 4, 4, 0.2*w, 0.8*w)
        draw_grid(vg, 4, 8, 0, 0.2*w)

        #weak highlight
        vg.path do |vg|
            vg.rect(0.2*w, 0, 0.8*w, h)
            vg.fill_color light_filll
            vg.fill
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
        m = 1
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
            if(i >= 2)
                next
            end
            scale = h/80
            vg.path do |vg|
                vg.rect(xx-scale,yy-scale,scale*2,scale*2);
                vg.fill_color NVG.rgba(0,0,0,255)
                #if(env.selected == i)
                #    vg.stroke_color sel_color
                #else
                    vg.stroke_color bright
                #end

                vg.stroke_width scale*0.5
                vg.fill
                vg.stroke
            end
        end
    }
}
