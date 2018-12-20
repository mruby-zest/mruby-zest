Widget {
    id: vis_eq
    property Object valueRef: nil
    property Array  coeff: nil
    property Bool   doUpdate: false
    onExtern: {
        vis_eq.valueRef = OSC::RemoteParam.new($remote, vis_eq.extern)
        vis_eq.valueRef.callback = lambda {|x| vis_eq.update_coeff x}
    }

    function refresh() {
        self.valueRef.refresh if valueRef
    }

    function update_coeff(x)
    {
        return if self.coeff == x
        n2 = x.length/2
        self.coeff = x
        self.doUpdate = true
    }

    function animate()
    {
        return if !doUpdate
        self.doUpdate = false
        xpts = Draw::DSP::logspace(1, 20000, 256)
        pts  = eq_response(xpts, coeff)
        ypts = []
        pts.each do |pt|
            ypts << Math.log10(pt)/4
        end
        data_view.data = ypts
        data_view.damage_self
    }

    function draw(vg)
    {
        fixedpad = 5
        pad  = 0
        pad2 = (1-2*pad)
        box = Rect.new(w*pad  + fixedpad,   h*pad  + fixedpad,
                       w*pad2 - 2*fixedpad, h*pad2 - 2*fixedpad)
        vg.path do
            vg.rect(box.x, box.y, box.w, box.h)
            vg.fill_color Theme::VisualBackground
            vg.fill
        end
        Draw::Grid::log_x(vg, 1, 201, box)
        Draw::Grid::linear_y(vg, 0, 8, box)
    }
    DataView {
        id: data_view
        normal: false
        pad: 0
        fixedpad: 5
    }
}
