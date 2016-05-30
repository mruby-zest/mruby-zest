Widget {
    id: env

    property Object prev: nil;
    property Int    selected: nil;
    //                      0         1         2         3         4
    property Array points: [0.0, 0.0, 0.5, 0.2, 0.3, 0.7,-0.9, 0.8, 0.0, 1.0];

    function onMousePress(ev) {
        puts "I got a mouse press (value)"
        #//Try to identify the location  of the nearest grabbable point
        #valuator.prev = ev.pos
        dat = env.points
        next_sel = 0
        best_dist = 1e10

        mx = ev.pos.x-global_x
        my = ev.pos.y-global_y
        (0...(dat.length/2)).each do |i|
            xx = w*dat[2*i+1];
            yy = h/2-h/2*dat[2*i];

            dst = (mx-xx)**2 + (my-yy)**2
            if(dst < best_dist)
                best_dist = dst
                next_sel  = i
            end
        end
        #print "selected = "
        #puts next_sel
        if(env.selected != next_sel)
            env.selected = next_sel
            env.root.damage_item env
        end
        env.prev = ev.pos
    }

    function onMouseMove(ev) {
        #puts "I got a mouse move (value)"
        if(env.selected)
            dy = 2*(ev.pos.y - env.prev.y)/env.h
            dx = (ev.pos.x - env.prev.x)/env.w
            if(env.selected == 0 || env.selected == (env.points.length)/2-1)
                env.points[env.selected*2] -= dy
            else
                env.points[env.selected*2+1] += dx
                env.points[env.selected*2]   -= dy
            end
            #print "("
            #print dx
            #print ","
            #print dy
            #print ")\n"
            #updatePos(dy/200.0)
            (0...env.points.length).each do |i|
                if(env.points[i] < -1)
                    env.points[i] = -1 
                elsif(env.points[i] > 1)
                    env.points[i] = 1
                end
            end
            env.prev = ev.pos
            env.root.damage_item env
        end
        #if(ev.buttons.include? :leftButton)
        #    dy = ev.pos.y - valuator.prev.y
        #    updatePos(dy/200.0)
        #    valuator.prev = ev.pos
        #end
    }

    function class_name()
    {
        "Envelope"
    }

    function draw(vg)
    {
        dat = env.points

        fill_color   = color("232C36")
        stroke_color = NVG.rgba(0x01, 0x47, 0x67,255)

        light_fill   = NVG.rgba(0x11,0x45,0x75,55)
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
                if(env.selected == i)
                    vg.stroke_color sel_color
                else
                    vg.stroke_color bright
                end

                vg.stroke_width scale*0.5
                vg.fill
                vg.stroke
            end
        end
    }
    Widget {
        id: run_view
        //animation layer
        layer: 1

        //extern is cloned
        extern: run_view.parent.extern

        function class_name()
        {
            "LfoVisAnimation"
        }

        //Workaround due to buggy nested properties
        function valueRef=(value_ref)
        {
            @value_ref = value_ref
        }

        function valueRef()
        {
            @value_ref
        }

        function runtime_points=(pts)
        {
            @runtime_points = pts
            puts pts
        }

        onExtern: {
            puts
            puts "extern"
            puts "extern value is"
            puts run_view.extern.inspect
            return if run_view.extern.nil?
            meta = OSC::RemoteMetadata.new($remote, run_view.extern)

            puts run_view.methods.sort
            run_view.valueRef = OSC::RemoteParam.new($remote, run_view.extern)
            run_view.valueRef.callback = Proc.new {|x|
                run_view.runtime_points = x;
                run_view.root.damage_item run_view
                run_view.valueRef.watch run_view.extern
            }
            puts "watching"
            run_view.valueRef.watch run_view.extern
        }

        function draw(vg)
        {
            sel_color    = NVG.rgba(0x00, 0xff, 0x00, 255)
            dim_color    = NVG.rgba(0x11,0x45,0x75,155)
            #Draw the data
            print '*'
            pts   = @runtime_points
            pts ||= []
            (0...(pts.length/2)).each do |i|
                xx = w*(pts[2*i]-1)*0.33
                yy = h-h*pts[2*i+1]

                scale = h/80
                vg.path do |vg|
                    vg.rect(xx-scale,yy-scale,scale*2,scale*2);
                    vg.fill_color NVG.rgba(0,0,0,255)
                    vg.stroke_color sel_color

                    vg.stroke_width scale*0.5
                    vg.fill
                    vg.stroke
                end
                
                vg.path do |v|
                    v.move_to(xx, 0)
                    v.line_to(xx, h)
                    v.stroke_color dim_color
                    v.stroke
                end
            end
        }
    }
}
