Widget {
    id: vis_sub
    onExtern: {
        return if vis_sub.extern.nil?
        #meta = OSC::RemoteMetadata.new($remote, vis_sub.extern)

        vis_sub.valueRef = OSC::RemoteParam.new($remote, vis_sub.extern)
        vis_sub.valueRef.callback = lambda {|x| vis_sub.update_coeff x}
    }

    property Object valueRef: nil
    property Bool   next_coeff: nil

    function refresh()
    {
        valueRef.refresh if valueRef
    }

    function update_coeff(x)
    {
        x = [x] if x.class != Array
        self.next_coeff = x
    }

    function do_update_coeff(x)
    {
        now = Time.new
        xpts = Draw::DSP::logspace(400, 20000, 512)
        tmp = sub_synth_response(xpts, x)
        ypts = tmp.map { |x| Math.log10(x)/4 }

        #max  = Draw::DSP::ary_max ypts
        #ypts = ypts.map { |x| x - max + 1}

        data_view.data = ypts
        root.damage_item data_view
        t2 = Time.new
    }

    function draw(vg)
    {
        fixedpad = 5
        background Theme::VisualBackground
        box = Rect.new(fixedpad, fixedpad, w-2*fixedpad, h-2*fixedpad)
        Draw::Grid::log_x(vg, 400, 20000, box)
        Draw::Grid::linear_y(vg, 1, 10, box, 1, 40)
    }

    DataView {
        id: data_view
        normal: false
        pad: 0.0
        fixedpad: 5

        function animate()
        {
            if(vis_sub.next_coeff)
                vis_sub.do_update_coeff(vis_sub.next_coeff)
                vis_sub.next_coeff = nil
            end
        }
    }
}
