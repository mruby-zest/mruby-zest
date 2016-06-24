Widget {
    id: env

    property Object prev: nil;
    property Int    selected: nil;
    property Array  xpoints: [0.0, 0.2, 0.7, 0.8, 1.0]
    property Array  ypoints: [0.0, 0.5, 0.3, -0.9, 0.0]

    property Int    points: 5
    property Int    sustain_point: 3
    property Object valueRef: nil

    onExtern: {
        ext = env.extern
        xpts = OSC::RemoteParam.new($remote, ext + "envdt")
        ypts = OSC::RemoteParam.new($remote, ext + "envval")
        pts = OSC::RemoteParam.new($remote, ext + "Penvpoints")
        pts.mode = :selector
        sus = OSC::RemoteParam.new($remote, ext + "Penvsustain")
        xpts.callback = lambda { |x|
            env.xpoints = x
            env.damage_self
        }
        ypts.callback = lambda { |x|
            env.ypoints = x.map {|xx| 2*xx-1}
            env.damage_self
        }
        pts.callback = lambda { |x|
            env.points = x
            env.damage_self
        }
        sus.callback = lambda { |x|
            env.sustain_point = x
            env.damage_self
        }
        env.valueRef = [xpts, ypts, pts, sus]
    }

    function refresh() {
        env.valueRef.each do |v|
            v.refresh
        end
    }

    function get_x_points() {
        Draw::DSP::norm_0_1(Draw::DSP::cumsum(xpoints[0...points]))
    }

    function onMousePress(ev) {
        puts "I got a mouse press (value)"
        #//Try to identify the location  of the nearest grabbable point
        #valuator.prev = ev.pos
        xdat = get_x_points()
        ydat = env.ypoints
        n = [xdat.length, ydat.length].min
        next_sel = 0
        best_dist = 1e10

        mx = ev.pos.x-global_x
        my = ev.pos.y-global_y
        (0...n).each do |i|
            xx = w*xdat[i];
            yy = h/2-h/2*ydat[i];

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

    function bound_points(array)
    {
        n = array.length
        (0...n).each do |i|
            if(array[i] < -1)
                array[i] = -1 
            elsif(array[i] > 1)
                array[i] = 1
            end
        end
    }

    function onMouseMove(ev) {

        if(env.selected)
            dy = 2*(ev.pos.y - env.prev.y)/env.h
            dx = (ev.pos.x - env.prev.x)/env.w
            n  = [env.xpoints.length, env.ypoints.length].min
            if(env.selected == 0 || env.selected == n-1)
                env.ypoints[env.selected] -= dy
            else
                env.xpoints[env.selected] += dx
                env.ypoints[env.selected] -= dy
            end

            bound_points(env.xpoints)
            bound_points(env.ypoints)

            env.prev = ev.pos
            env.root.damage_item env
        end
    }

    function class_name()
    {
        "Envelope"
    }

    function draw(vg)
    {
        xdat = get_x_points()
        ydat = env.ypoints
        n    = [xdat.length, ydat.length].min

        fill_color   = Theme::VisualBackground
        stroke_color = Theme::VisualStroke
        light_fill   = Theme::VisualLightFill
        bright       = Theme::VisualBright
        dim          = Theme::VisualDim
        sel_color    = Theme::VisualSelect

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
            (0...n).each do |i|
                vg.line_to(w*xdat[i], h/2-h/2*ydat[i]);
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
            (0...n).each do |i|
                vg.line_to(w*xdat[i], h/2-h/2*ydat[i]);
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

        begin
            m = 2
            #Draw Sel Line
            if(m >= 0 && m < n)
                vg.path do |v|
                    v.move_to(w*xdat[m], 0)
                    v.line_to(w*xdat[m], h)
                end
                vg.stroke_color(dim);
                vg.stroke
            end
        end

        #Draw Actual Line
        vg.path do |vg|
            vg.move_to(w*xdat[0],h/2-h/2*ydat[0])
            (0...n).each do |i|
                vg.line_to(w*xdat[i], h/2-h/2*ydat[i]);
            end
            vg.stroke_width 3.0
            vg.stroke_color bright
            vg.stroke
        end
        vg.stroke_width 1.0

        (0...n).each do |i|
            xx = w*xdat[i];
            yy = h/2-h/2*ydat[i];
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
            return if run_view.extern.nil?
            meta = OSC::RemoteMetadata.new($remote, run_view.extern)

            puts run_view.methods.sort
            run_view.valueRef = OSC::RemoteParam.new($remote, run_view.extern)
            run_view.valueRef.callback = Proc.new {|x|
                run_view.runtime_points = x;
                run_view.root.damage_item run_view
                run_view.valueRef.watch run_view.extern
            }
            run_view.valueRef.watch run_view.extern
        }

        function draw(vg)
        {
            sel_color    = Theme::VisualSelect
            dim_color    = Theme::VisualDimTrans
            #Draw the data
            pts   = @runtime_points
            pts ||= []
            (0...(pts.length/2)).each do |i|
                xx = w*(pts[2*i]-1)*0.33
                yy = h-h*pts[2*i+1]

                scale = h/80
                vg.path do |vg|
                    vg.rect(xx-scale,yy-scale,scale*2,scale*2);
                    vg.fill_color color(:black)
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
