Widget {
    id: voice_item
    property Int   num:     0
    property Array weights: [0.05, 0.05, 0.2, 0.2, 0.3, 0.2]

    //voice ID
    Button {
        label: voice_item.num.to_s;
        layoutOpts: [:no_constraint]
    }
    //mini wave view
    WaveView {
        extern: voice_item.extern + "OscilSmp/waveform"
        grid: false
    }
    //volume
    HSlider {
        extern: voice_item.extern + "PVolume"
        label: "20%"
    }
    //pan
    HSlider {
        extern: voice_item.extern + "PPanning"
        label: "centered";
        centered: true;
        value: 0.5
    }
    //detune
    HSlider {
        extern: voice_item.extern + "PDetune"
        label: "+0 cents";
        centered: true;
        value: 0.5
    }

    //vib depth
    HSlider {
        extern: voice_item.extern + "FreqLfo/Pintensity"
        label: "100%"
    }

    function draw(vg)
    {
        background Theme::GeneralBackground
    }

    function layout(l)
    {
        selfBox = l.genBox :zavlr, self
        chBox   = []

        off = 0.0
        children.each_with_index do |ch, ind|
            weight = weights[ind]
            box    = ch.layout(l)
            l.fixed(box, selfBox, off, 0.0, weight, 1.0)
            off += weight
        end
        selfBox
    }
}
