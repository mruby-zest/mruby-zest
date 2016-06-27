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
       return if(x == vis_filter.coeff)
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
       xpts = Draw::DSP::logspace(1, 20000, 256)
       ypts = []
       xpts.each do |pt|
           ypts << Math.log10(Draw::DSP::magnitude(b, a, pt/48000, x[0]+1))/4
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
        Draw::Grid::linear_y(vg, 1, 20, Rect.new(0, 0, w, h))
    }

    DataView {
        id: data_view
        normal: false
        pad: 0
    }
}
