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

    property Object valueRef: nil

    function onSetup(old=nil)
    {
        refs = []
        base = lfo_vis.extern
        type_var = OSC::RemoteParam.new($remote, base+"PLFOtype")
        type_var.mode = :options
        type_var.callback = lambda {|x|
            ntype = [:sine, :triangle, :square, :rampup,
                :rampdown, :exp1, :exp2][x]
            return if(ntype == lfo_vis.type)
            lfo_vis.type = [:sine, :triangle, :square, :rampup,
                :rampdown, :exp1, :exp2][x]}

        depth_var = OSC::RemoteParam.new($remote, base+"Pintensity")
        depth_var.callback = lambda {|x|
            lfo_vis.depth = x
            lfo_vis.damage_self}

        delay_var = OSC::RemoteParam.new($remote, base+"Pdelay")
        delay_var.callback = lambda {|x|
            lfo_vis.delay_time = 2000*x
            lfo_vis.damage_self}

        freq_var  = OSC::RemoteParam.new($remote, base+"Pfreq")
        freq_var.callback = lambda {|x|
            lfo_vis.period = 2000*x
            lfo_vis.damage_self}

        phase_var = OSC::RemoteParam.new($remote, base+"Pstartphase")
        phase_var.callback = lambda {|x|
            lfo_vis.phase = x
            lfo_vis.updateType
            lfo_vis.damage_self}


        refs << type_var
        refs << depth_var
        refs << phase_var
        self.valueRef = refs

    }

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
                damage_self
            elsif(lfo_vis.drag_type == :lfo)
                lfo_vis.drag_prev = ev.pos
                dv = lfo_vis.depth + dy/100.0
                dv = [1, [0, dv].max].min
                lfo_vis.depth = dv

                dt = 100*Math.exp(Math.log(0.01*lfo_vis.period) + dx/100.0)
                #dt = lfo_vis.delay_time + dx/2.0
                dt = [1500, [20, dt].max].min
                lfo_vis.period = dt
                damage_self
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
        damage_self
    }

    onType: {
        lfo_vis.updateType
    }


    function draw(vg)
    {
        padfactor = 10
        bb = Draw::indent(Rect.new(0,0,w,h), padfactor, padfactor)

        background Theme::VisualBackground

        dat = lfo_vis.points
        updateType if dat.empty?
        dat = lfo_vis.points
        if(dat.empty?)
            puts "[Zyn-Zest:ERROR] LfoVis - um, it's empty..."
            return
        end

        fill_color   = Theme::VisualBackground
        stroke_color = Theme::VisualStroke
        light_fill   = Theme::VisualLightFill
        light_filll  = color("911515", 20)
        bright       = Theme::VisualBright
        dim          = Theme::VisualDim
        sel_color    = Theme::VisualSelect

        background fill_color

        draw_grid(vg, lfo_vis.depth*16, lfo_vis.period/10,
                  bb.x+0.2*bb.w, bb.y, 0.8*bb.w, bb.h)
        draw_grid(vg, lfo_vis.depth*16, lfo_vis.delay_time/100,
                  bb.x,          bb.y, 0.2*bb.w, bb.h)

        #weak highlight
        vg.path do |vg|
            vg.rect(0.2*w, 0, 0.8*w, h)
            vg.fill_color light_filll
            vg.fill
        end

        pts = Draw::toPos(dat)

        #Draw Highlights
        Draw::WaveForm::under_highlight(vg, bb, pts, light_fill)
        Draw::WaveForm::over_highlight(vg,  bb, pts, light_fill)

        #Draw Zero Line
        Draw::WaveForm::zero_line(vg, bb, dim)

        Draw::WaveForm::env_sel_line(vg, bb, 1, pts, dim)

        #Draw Actual Line
        Draw::WaveForm::lfo_plot(vg, bb, pts, bright)

        vg.fill_color   color(:black)
        vg.stroke_color bright
        (0...(dat.length/2)).each do |i|
            xx = bb.x + bb.w*dat[2*i+1];
            yy = bb.y + bb.h/2*(1-dat[2*i]);
            next if(i >= 2)
            Draw::WaveForm::env_marker(vg, xx, yy, 3)
        end
    }


    Widget {
        id: run_view
        //animation layer
        layer: 1

        //extern is cloned
        extern: lfo_vis.extern + "out"

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

        function runtime_points()
        {
            @runtime_points
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
                if(run_view.runtime_points != x)
                    run_view.runtime_points = x;
                    run_view.damage_self
                end
            }
        }

        function animate() {
            return if run_view.valueRef.nil?
            run_view.valueRef.watch run_view.extern
        }

        function draw(vg)
        {
            #Draw the data
            pts   = @runtime_points
            pts ||= []

            padfactor = 10
            bb = Draw::indent(Rect.new(0,0,w,h), padfactor, padfactor)

            Draw::WaveForm::overlay_lfo(vg, bb, pts)
        }
    }
}
