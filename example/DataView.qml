Widget {
    layer: 1
    property Array data: nil;
    property Bool  normal: true
    property Float pad:   1/32
    property Float fixedpad: 0
    property Float phase: 0
    property Bool  ignore_phase: false
    property Bool under_highlight: false

    function class_name() { "DataView" }

    function draw(vg)
    {
        pad2 = (1-2*pad)

        box = Rect.new(w*pad  + fixedpad,   h*pad  + fixedpad,
                       w*pad2 - 2*fixedpad, h*pad2 - 2*fixedpad)

        vphase = ignore_phase ? 0 : phase

        if(data.class == Array && data[0].class == Float)
            Draw::WaveForm::plot(vg, self.data, box, normal, vphase, under_highlight)

        elsif(data.class == Array && data[0] == -40)
            Draw::WaveForm::plot(vg, self.data, box, normal, vphase)

        elsif(data.class == Array && data[0] == 0 && data[5] == 0)
            Draw::WaveForm::plot(vg, self.data, box, false, vphase)

        elsif(data.class == Array && data[0].class == Array)
            Draw::WaveForm::plot(vg, self.data[0], box, normal, vphase)
            Draw::WaveForm::plot(vg, self.data[1], box, normal, vphase)

        else
            Draw::WaveForm::sin(vg, box)
        end
    }
}

