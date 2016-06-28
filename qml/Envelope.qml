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

        padfactor = 20
        bb = Draw::indent(Rect.new(0,0,w,h), padfactor, padfactor)

        background(fill_color)

        #Draw Highlights
        Draw::WaveForm::under_highlight(vg, bb, xdat, ydat, light_fill)
        Draw::WaveForm::over_highlight(vg,  bb, xdat, ydat, light_fill)

        #Draw Zero Line
        Draw::WaveForm::zero_line(vg, bb, dim)

        #Indicate Sustain Point
        Draw::WaveForm::env_sel_line(vg, bb, 2, xdat, dim)

        #Draw Actual Line
        Draw::WaveForm::env_plot(vg, bb, xdat, ydat, bright, selected)
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
        }

        onExtern: {
            return if run_view.extern.nil?
            meta = OSC::RemoteMetadata.new($remote, run_view.extern)

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

            padfactor = 20
            bb = Draw::indent(Rect.new(0,0,w,h), padfactor, padfactor)

            Draw::WaveForm::overlay(vg, bb, pts)
        }
    }
}
