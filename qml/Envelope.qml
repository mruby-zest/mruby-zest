Widget {
    id: env

    property Object prev: nil;
    property Int    selected: nil;
    property Array  xpoints: [0.0, 0.2, 0.7, 0.8, 1.0]
    property Array  ypoints: [0.0, 0.5, 0.3, -0.9, 0.0]

    property Int    points: 5
    property Int    sustain_point: 3
    property Object valueRef: nil
    property Bool   mouse_enable: true
    property Function whenTime: nil
    property Int      emode: nil

    function setup_valuerefs()
    {
        ext = env.extern
        xpts = OSC::RemoteParam.new($remote, ext + "envdt")
        ypts = OSC::RemoteParam.new($remote, ext + "envval")
        pts = OSC::RemoteParam.new($remote, ext + "Penvpoints")
        pts.mode = :selector
        sus = OSC::RemoteParam.new($remote, ext + "Penvsustain")
        sus.mode = :full
        free = OSC::RemoteParam.new($remote, ext + "Pfreemode")
        mode = OSC::RemoteParam.new($remote, ext + "Envmode")
        mode.mode = :selector
        xpts.callback = lambda { |x|
            env.xpoints = x
            env.damage_self
            whenTime.call if whenTime
        }
        ypts.callback = lambda { |x|
            env.ypoints = x.map {|xx| 2*xx-1}
            env.damage_self
        }
        pts.callback = lambda { |x|
            env.points = x
            env.damage_self
            whenTime.call if whenTime
        }
        sus.callback = lambda { |x|
            env.sustain_point = x
            env.damage_self
        }
        free.callback = lambda { |x|
            env.mouse_enable = x
        }
        mode.callback = lambda { |x|
            env.emode = x
        }
        env.valueRef = [xpts, ypts, pts, sus, free, mode]

        run_view.extern = env.extern+"out"
    }

    onExtern: {
        env.setup_valuerefs
    }

    function refresh() {
        return if self.valueRef.nil?
        self.valueRef.each do |v|
            v.refresh
        end
    }

    function get_x_points() {
        cumsum = Draw::DSP::cumsum(xpoints[0...points])
        tmp = Draw::DSP::norm_0_1(cumsum)

        #we need to make sure that the envelopes starts at 0 and finishes at 1
        #(otherwise, the graph won't be displayed correctly)
        tmp[0] = 0
        tmp[-1] = 1

        Draw::DSP::pad_norm(tmp, 0.0001)
    }

    function warp(x)
    {
        wp = get_x_points()
        y  = []
        x.each_with_index do |xx, i|
            if((i%2) == 1)
                y << xx
            else
                ps = xx.to_i
                fr = xx-ps
                ps -= 1
                y << xx if(ps >= wp.length)
                next    if(ps >= wp.length)
                aa = wp[ps]
                bb = wp[ps]
                bb = wp[ps+1] if(ps+1 < wp.length)
                y << aa+fr*(bb-aa)
            end
        end
        y
    }

    function onMousePress(ev) {
        #return if !self.mouse_enable
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
        if(env.selected != next_sel)
            env.selected = next_sel
            env.root.damage_item env
        end
        env.prev = ev.pos
    }

    function bound_points(array, low, high)
    {
        n = array.length
        (0...n).each do |i|
            if(array[i] < low)
                array[i] = low
            elsif(array[i] > high)
                array[i] = high
            end
        end
    }

    function onMouseMove(ev) {
        #return if !self.mouse_enable

        if(env.selected)
            scalex = 4*(env.xpoints[env.selected]+10)
            dy = 2*(ev.pos.y - env.prev.y)/env.h
            dx = scalex*(ev.pos.x - env.prev.x)/env.w
            n  = [env.xpoints.length, env.ypoints.length].min
            if(env.selected == 0 || env.selected == n-1)
                env.ypoints[env.selected] -= dy
            else
                env.xpoints[env.selected] += dx
                env.ypoints[env.selected] -= dy
            end

            bound_points(env.xpoints,  0.0, 40950.0)
            bound_points(env.ypoints, -1.0, 1.0)

            send_points() if mouse_enable
            update_nonfree_x(env.xpoints) if !mouse_enable
            update_nonfree_y(env.ypoints) if !mouse_enable

            env.prev = ev.pos
            env.root.damage_item env
        end
    }

    function cvt_x(x)
    {
        fval = Math::log2(x/10.0 + 1.0) * 127.0/12.0
        [0, [127, fval.round].min].max.to_i
    }

    function update_nonfree_x(pts)
    {
        if(emode == 1)
            $remote.seti(extern + "PA_dt", cvt_x(pts[1]))
            $remote.seti(extern + "PD_dt", cvt_x(pts[2]))
            $remote.seti(extern + "PR_dt", cvt_x(pts[3]))
        elsif(emode == 2)
            $remote.seti(extern + "PA_dt", cvt_x(pts[1]))
            $remote.seti(extern + "PD_dt", cvt_x(pts[2]))
            $remote.seti(extern + "PR_dt", cvt_x(pts[3]))
        elsif(emode == 3)
            $remote.seti(extern + "PA_dt", cvt_x(pts[1]))
            $remote.seti(extern + "PR_dt", cvt_x(pts[2]))
        elsif(emode == 4)
            $remote.seti(extern + "PA_dt", cvt_x(pts[1]))
            $remote.seti(extern + "PD_dt", cvt_x(pts[2]))
            $remote.seti(extern + "PR_dt", cvt_x(pts[3]))
        elsif(emode == 5)
            $remote.seti(extern + "PA_dt", cvt_x(pts[1]))
            $remote.seti(extern + "PR_dt", cvt_x(pts[2]))
        end
        whenTime.call if whenTime
    }

    function cvt_y(x)
    {
        [0, [127, 127*(x+1)/2].min].max.to_i
    }

    function update_nonfree_y(pts)
    {
        if(emode == 1)
            pts[0]      = -1.0
            pts[1]      = +1.0
            $remote.seti(extern + "PS_val", cvt_y(pts[2]))
            pts[3]      = -1.0
        elsif(emode == 2)
            pts[0]      = -1.0
            pts[1]      = +1.0
            $remote.seti(extern + "PS_val", cvt_y(pts[2]))
            pts[3]      = -1.0
        elsif(emode == 3)
            $remote.seti(extern + "PA_val", cvt_y(pts[0]))
            pts[1]      = 0.0
            $remote.seti(extern + "PR_val", cvt_y(pts[2]))
        elsif(emode == 4)
            $remote.seti(extern + "PA_val", cvt_y(pts[0]))
            $remote.seti(extern + "PD_val", cvt_y(pts[1]))
            pts[2]      = 0.0
            $remote.seti(extern + "PR_val", cvt_y(pts[3]))
        elsif(emode == 5)
            $remote.seti(extern + "PA_val", cvt_y(pts[0]))
            pts[1]      = 0.0
            $remote.seti(extern + "PR_val", cvt_y(pts[2]))
        end
    }


    function send_points()
    {
        return if self.extern.nil?
        ry = ypoints.map {|xx| (xx+1)/2}
        valueRef[0].value = env.xpoints
        valueRef[1].value = ry
    }

    function class_name()
    {
        "Envelope"
    }

    function draw(vg)
    {
        xdat = get_x_points()
        ydat = env.ypoints

        fill_color    = Theme::VisualBackground
        stroke_color  = Theme::VisualStroke
        light_fill    = Theme::VisualLightFill
        bright        = Theme::VisualBright
        dim           = Theme::VisualDim
        sel_color     = Theme::VisualSelect
        sustain_color = Theme::SustainPoint

        padfactor = 12
        bb = Draw::indent(Rect.new(0,0,w,h), padfactor, padfactor)

        pts = Draw::zipToPos(xdat, ydat)

        background(fill_color)

        #Draw borders of the envelope display
        vg.translate(0.5, 0.5)
        vg.path do |v|
            v.stroke_width = 1
            v.stroke_color = Theme::GridLine
            v.rounded_rect(bb.x.round(), bb.y.round(), bb.w.round(), bb.h.round(), 2)
            v.stroke()
        end
        vg.translate(-0.5, -0.5)

        #Draw Highlights
        Draw::WaveForm::under_highlight(vg, bb, pts, light_fill)
        Draw::WaveForm::over_highlight(vg,  bb, pts, light_fill)

        #Draw Zero Line
        Draw::WaveForm::zero_line(vg, bb, dim)

        #Indicate Sustain Point
        Draw::WaveForm::env_sel_line(vg, bb, self.sustain_point, pts, sustain_color)

        #Draw Actual Line
        Draw::WaveForm::env_plot(vg, bb, pts, bright, selected)

    }
    Widget {
        id: run_view
        //animation layer
        layer: 1

        //extern is cloned
        extern: run_view.parent.extern

        function class_name()
        {
            "EnvVisAnimation"
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
            run_view.valueRef = OSC::RemoteParam.new($remote, run_view.extern)
            run_view.valueRef.set_watch
            run_view.valueRef.callback = Proc.new {|x|
                run_view.update_points(env.warp(x))
                run_view.runtime_points = env.warp(x);
                run_view.root.damage_item run_view
            }
        }

        function update_points(xx)
        {
            self.runtime_points = xx
            damage_self

            @last = Time.new
        }

        function animate()
        {
            run_view.valueRef.watch run_view.extern
            now     = Time.new
            @last ||= now
            update_points([]) if((now-@last)>0.1)
        }

        function draw(vg)
        {
            sel_color    = Theme::VisualSelect
            dim_color    = Theme::VisualDimTrans
            #Draw the data
            pts   = @runtime_points
            pts ||= []
            return if pts.class != Array

            padfactor = 20
            bb = Draw::indent(Rect.new(0,0,w,h), padfactor, padfactor)

            Draw::WaveForm::overlay(vg, bb, pts)
        }
    }
}
