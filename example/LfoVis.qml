Widget {
    id: lfo_vis

    property Array  points: []
    property Symbol type: :triangle
    property Symbol drag_type: nil
    property Pos    drag_prev: nil

    property Float    phase:      0.0
    property Float    depth:      0.5
    property MilliSec delay_time: 100
    property MilliSec period:     1000

    property Time     time: nil

    function class_name()
    {
        "LfoVis"
    }

    //Identify the region of the window used for drag events
    function onMousePress(ev)
    {
        loc_x = ev.pos.x - lfo_vis.global_x
        if(loc_x < 0.2*lfo_vis.w)
            lfo_vis.drag_type = :delay
        else
            lfo_vis.drag_type = :lfo
        end
        lfo_vis.drag_prev = ev.pos
    }

    function onMouseMove(ev)
    {
        if(lfo_vis.drag_prev)
            dx = ev.pos.x - lfo_vis.drag_prev.x
            dy = ev.pos.y - lfo_vis.drag_prev.y

            if(lfo_vis.drag_type == :delay)
                #dv = lfo_vis.phase + dy/100.0
                #dv_ = [1, [0, dv].max].min
                #lfo_vis.phase = dv_
                #lfo_vis.drag_prev.y = ev.pos.y if(dv == dv_)
                #lfo_vis.updateType

                dt = 100*Math.exp(Math.log(0.01*lfo_vis.delay_time) + dx/100.0)
                dt_ = [4000, [0, dt].max].min
                lfo_vis.delay_time = dt_
                lfo_vis.drag_prev.x = ev.pos.x if(dt == dt_)
                root.damage_item self
            elsif(lfo_vis.drag_type == :lfo)
                lfo_vis.drag_prev = ev.pos
                dv = lfo_vis.depth + dy/100.0
                dv = [1, [0, dv].max].min
                lfo_vis.depth = dv

                dt = 100*Math.exp(Math.log(0.01*lfo_vis.period) + dx/100.0)
                #dt = lfo_vis.delay_time + dx/2.0
                dt = [1500, [20, dt].max].min
                lfo_vis.period = dt
                root.damage_item self
            end
        end
    }

    function updateType()
    {
        shape = case lfo_vis.type
        when :triangle
            Proc.new {|phase|
                if(phase >= 0 && phase < 0.25)
                    4.0 * phase
                elsif(phase >= 0.25 && phase < 0.75)
                    2.0 - 4 * phase
                else
                    4.0 * phase - 4;
                end
            }
        when :square
            Proc.new {|phase|
                if(phase < 0.5)
                    -1.0
                else
                    1.0
                end
            }
        when :rampup
            Proc.new {|phase| (phase - 0.5) * 2.0}
        when :rampdown
            Proc.new {|phase| (0.5 - phase) * 2.0};
        when :exp1
            Proc.new {|phase| (0.05 ** phase) * 2.0 - 1.0}
        when :exp2
            Proc.new {|phase| (0.001 ** phase) * 2.0 - 1.0}
        else
            Proc.new {|x| Math.sin(2*3.14*x) }
        end

        # root point
        p = [0,0, 0, 0.2]
        # func points
        resolution = 128
        (0..resolution).each do |i|
            x = 0.2+0.8*i/resolution
            phase = i/resolution + lfo_vis.phase
            phase -= 1 if phase > 1

            y = shape.call(phase)
            p << y
            p << x
        end
        lfo_vis.points = p
    }

    onType: {
        lfo_vis.updateType
    }


    function draw(vg)
    {
        puts "?"
        if(lfo_vis.time.nil?)
            lfo_vis.time = Time.new
        else
            ntime = Time.new
            puts ntime - lfo_vis.time
            lfo_vis.time = ntime
        end

        vg.path do |v|
            v.rect(0,0,w,h)
            v.fill_color color("232C36")
            v.fill
        end

        dat = lfo_vis.points
        updateType if dat.empty?
        dat = lfo_vis.points
        if(dat.empty?)
            puts "um, it's empty..."
            return
        end

        fill_color   = color("232C36")
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

        draw_grid(vg, lfo_vis.depth*16, lfo_vis.period/10, 0.2*w, 0.8*w,  h)
        draw_grid(vg, lfo_vis.depth*16, lfo_vis.delay_time/100, 0, 0.2*w, h)

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


    Widget {
        id: run_view
        //animation layer
        layer: 1

        //extern is cloned
        extern: lfo_vis.extern

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
        }

        onExtern: {
            #puts
            #puts "extern"
            #puts "extern value is"
            #puts run_view.extern.inspect
            return if run_view.extern.nil?
            meta = OSC::RemoteMetadata.new($remote, run_view.extern)

            puts run_view.methods.sort
            run_view.valueRef = OSC::RemoteParam.new($remote, run_view.extern)
            run_view.valueRef.callback = Proc.new {|x|
                run_view.runtime_points = x;
                run_view.root.damage_item run_view
                run_view.valueRef.watch run_view.extern
            }
            #puts "watching"
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
                xx = 0.2*w+0.8*w*pts[2*i]
                yy = h/2-h/2*pts[2*i+1]/127

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
