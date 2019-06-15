Widget {
    id: oscill 
    extern: "/part0/kit0/adpars/"
    property Array  opt_vals: []
    property Array  options: []
    function draw(vg){   
        fill_color    = Theme::VisualBackground
        dim           = Theme::VisualDim
        padfactor = 12
        bb = Draw::indent(Rect.new(0,0,w,h), padfactor, padfactor)
        background(fill_color)
        Draw::WaveForm::zero_line(vg, bb, dim)
        vg.translate(0.5, 0.5)
        vg.path do |v|
            v.stroke_width = 1
            v.stroke_color = Theme::GridLine
            v.rounded_rect(bb.x.round(), bb.y.round(), bb.w.round(), bb.h.round(), 2)
            v.stroke()
        end
        vg.translate(-0.5, -0.5)   
    }
    
         onExtern: {
            selector.options = oscill.options
            selector.opt_vals = oscill.opt_vals
            }

    Widget {
        id: run_view
        //animation layer
        layer: 1 
        extern: oscill.extern + "out"
        //Workaround due to buggy nested properties

        function valueRef=(value_ref){
            @value_ref = value_ref
        }

        function valueRef(){
            @value_ref
        }

        function runtime_points=(x){
            @runtime_points = x
        }

        onExtern: {
            return if run_view.extern.nil?
            run_view.valueRef = OSC::RemoteParam.new($remote, selector.opt_vals[selector.selected])
            run_view.valueRef.set_watch
            run_view.valueRef.callback = Proc.new {|x|
                run_view.runtime_points = x;
                run_view.damage_self
            }
        }

        function update_points(xx)
        {
            self.runtime_points = xx
            damage_self
            @last = Time.new
        }

        function animate(){
            return if run_view.valueRef.nil?
            run_view.valueRef.watch run_view.extern
            now     = Time.new
            @last ||= now
            default = [10] * 200
            update_points(default) if((now-@last)>0.1)
        }

        function draw(vg){
            padfactor = 12
            bb = Draw::indent(Rect.new(0,0,w,h), padfactor, padfactor) 
            return if  @runtime_points.nil?
            pts = @runtime_points
            Draw::WaveForm::plot(vg,pts,bb)
        }
    }

    function layout(l, selfBox) {
        main_width = 0.9
        main_width = layoutOpts[:main_width] if layoutOpts.include?(:main_width)
        Draw::Layout::hfill(l, selfBox, children,
        [main_width, 1-main_width], 0, 2)
    }

    Widget{
        ParModuleRow {
            lsize: 0.02
            Selector{
                id: selector
                label: "change watch point"
                whenValue: lambda {    
                run_view.valueRef = OSC::RemoteParam.new($remote, selector.opt_vals[selector.selected])
                run_view.valueRef.set_watch
                run_view.valueRef.callback = Proc.new {|x|
                run_view.runtime_points = x;
                run_view.damage_self
                    }
                }
            }
        }
        
    function draw(vg) {
            Draw::GradBox(vg, Rect.new(0,0,w,h))
        }
    }
} 
