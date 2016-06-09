Widget {
    id: vis_filter

    onExtern: {
        return if vis_filter.extern.nil?
        meta = OSC::RemoteMetadata.new($remote, vis_filter.extern)

        vis_filter.valueRef = OSC::RemoteParam.new($remote, vis_filter.extern)
        vis_filter.valueRef.callback = lambda {|x| vis_filter.update_coeff x}
    }

    function update_coeff(x)
    {
       #puts x
       #puts
       #puts
       return if(x == vis_filter.coeff)
       #puts "coeff"
       #puts x
       b = nil
       a = nil
       if(x.length == 7)
           b = x[1..3]
           a = x[4..6]
       elsif(x.length == 5)
           b = x[1..2]
           a = x[3..4]
       end
       vis_filter.coeff = x;
       #puts vis_filter.coeff
       xpts = Draw::DSP::logspace(1, 20000, 256)
       ypts = []
       xpts.each do |pt|
           ypts << Math.log10(Draw::DSP::magnitude(b, a, pt/48000, x[0]+1))
       end
       #puts ypts
       #vis_filter.xpoints = xpts
       data_view.data = ypts
       root = vis_filter.root
       root.damage_item data_view if root
    }

    extern: "/part0/kit0/adpars/GlobalPar/GlobalFilter/response"
    property Object valueRef: nil
    property Array  coeff:    nil

    function refresh()
    {
        self.valueRef.refresh if valueRef
    }

    function draw(vg)
    {
        background Theme::VisualBackground
        Draw::Grid::log_x(vg, 1, 20000, Rect.new(0, 0, w, h))
        Draw::Grid::linear_y(vg, 1, 20000, Rect.new(0, 0, w, h))

        #puts coeff
        ##puts ypoints.map {|x| Math.log10(x)}
        #return if ypoints.empty?
        #vg.path do |v|
        #    dx = w
        #    ch = h/2
        #    dy = h/8
        #    v.move_to(0, ch-dy*Math.log10(ypoints[0]))
        #    N = ypoints.length-1
        #    (1..N).each do |i|
        #        v.line_to(dx*i/N, ch-dy*Math.log10(ypoints[i]))
        #    end
        #    v.stroke_color color("00ff00")
        #    v.stroke
        #end
    }

    DataView {
        id: data_view
        normal: false
    }
}
