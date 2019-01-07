Widget {
    id: vis_filter

    property Object valueRef: nil
    property Object doUpdate: false
    property Array  coeff:    nil

    onExtern: {
        return if vis_filter.extern.nil?
        vis_filter.valueRef = OSC::RemoteParam.new($remote, vis_filter.extern)
        vis_filter.valueRef.callback = lambda {|x| vis_filter.update_coeff x}
    }

    function animate()
    {
        return if !doUpdate
        self.doUpdate = false
        x = self.coeff
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
        xpts = Draw::DSP::logspace(50, 30000, 256)
        xnorm = []
        xpts.each do |pt|
            xnorm << pt / 48000.0
        end
        yy = Draw::opt_magnitude(b, a, xnorm, x[0]+1)
        ypts = []
        yy.each do |pt|
            ypts << Math::log10(pt)/4
        end
        #vis_filter.xpoints = xpts
        data_view.data = ypts
        data_view.damage_self
    }

    function update_coeff(x)
    {
       return if(x == vis_filter.coeff)
       self.coeff = x
       self.doUpdate = true
    }

    function refresh()
    {
        self.valueRef.force_refresh if valueRef
    }

    function draw(vg)
    {
        fixedpad = 5
        pad  = 0
        pad2 = (1-2*pad)
        box = Rect.new(w*pad  + fixedpad,   h*pad  + fixedpad,
                       w*pad2 - 2*fixedpad, h*pad2 - 2*fixedpad)
        background Theme::VisualBackground
        Draw::Grid::log_x(vg, 50, 30000, box)
        Draw::Grid::linear_y(vg, 1, 10, box)
    }

    DataView {
        id: data_view
        normal: false
        pad: 0
        fixedpad: 5
        under_highlight: true
    }
}
