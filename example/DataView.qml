Widget {
    layer: 1
    property Array data: nil;
    property Bool  normal: true
    property Float pad:   1/32
    property Float fixedpad: 0
    property Float phase: 0

    function class_name() { "DataView" }

    function draw(vg)
    {
        pad2 = (1-2*pad)
        box = Rect.new(w*pad  + fixedpad,   h*pad  + fixedpad,
                       w*pad2 - 2*fixedpad, h*pad2 - 2*fixedpad)

        if(data)
            Draw::WaveForm::plot(vg, self.data, box, normal, phase)
        else
            Draw::WaveForm::sin(vg, box)
        end
    }
}

