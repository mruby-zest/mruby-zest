Widget {
    id: voice_item
    property Array weights: [0.05, 0.05, 0.2, 0.2, 0.3, 0.2]

    //voice ID
    Button { label: voice_item.label; layoutOpts: [:no_constraint]}
    //mini wave view
    WaveView { grid: false }
    //volume
    HSlider {}
    //pan
    HSlider { centered: true}
    //detune
    HSlider { centered: true}
    //vib depth
    HSlider {}

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
