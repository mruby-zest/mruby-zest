Widget {
    id: harmonic_view
    property Object valueRef: nil

    onExtern: {
        harmonic_view.valueRef =
            OSC::RemoteParam.new($remote, harmonic_view.extern)
        harmonic_view.valueRef.callback = lambda {|x|
            #x = x.map {|x| Math.log10(x)}
            x = Draw::DSP::norm_harmonics(x)
            x = x[0..255] if x.length > 256
            harmonic_view.points = x
            harmonic_view.damage_self
        }

    }

    function refresh()
    {
        self.valueRef.refresh if self.valueRef
    }

    function make_points()
    {
        pts = [1.0, 0.5, 0.0, 0.0, 0.7]
        loop {
            break if pts.length == 128
            pts << 0.0
        }
        pts
    }


    property Array points: harmonic_view.make_points

    function draw(vg)
    {
        pad  = 1/32
        pad2 = (1-2*pad)
        background Theme::VisualBackground
        bb = Rect.new(pad*w, pad*h, pad2*w, pad2*h)
        Draw::WaveForm::bar(vg, self.points, bb,Theme::HarmonicColor)
    }
}
