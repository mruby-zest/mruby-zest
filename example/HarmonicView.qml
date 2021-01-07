Widget {
    id: harmonic_view
    property Object type:     :osc
    property Object valueRef: nil

    onExtern: {
        rem   = harmonic_view.extern
        type  = harmonic_view.type
        rharm = rem                       if(type == :osc)
        rharm = rem + "oscilgen/spectrum" if(type == :pad)

        ref = OSC::RemoteParam.new($remote, rharm)
        ref.callback = lambda {|x|
            #x = x.map {|x| Math.log10(x)}
            x = Draw::DSP::norm_harmonics(x)
            nharmonics = 64
            x = x[0..nharmonics-1] if x.length > nharmonics
            harmonic_view.points = x
            harmonic_view.damage_self
        }
        refs = [ref]
        if(type == :pad)
            ref = OSC::RemoteParam.new($remote,rem + "nhr")
            ref.callback = lambda {|x|
                harmonic_view.shift = x
                harmonic_view.damage_self
            }
            refs << ref
        end

        harmonic_view.valueRef = refs

    }

    function refresh()
    {
        vr = self.valueRef
        if(vr)
            vr.each do |r|
                r.refresh
            end
        end
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
    property Array shift:  nil

    function draw(vg)
    {
        pad  = 1.0/32
        pad2 = (1-2*pad)
        background Theme::VisualBackground
        bb = Rect.new(pad*w, pad*h, pad2*w, pad2*h)
        Draw::WaveForm::bar(vg, self.points, bb,Theme::HarmonicColor, self.shift)
    }
}
