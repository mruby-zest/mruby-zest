Widget {
    id: col
    property Array weights: [0.05, 0.1, 0.65, 0.1, 0.05, 0.05]

    TextBox {
        bg: Theme::ButtonActive;
        height: 0.8;
        label: col.label
    }
    TextBox {
        bg: Theme::ButtonInactive
        height: 0.4
        label: "synth"
    }
    ColorBox {
        bg: Theme::GeneralBackground
        Slider {pad: 0.01}
        Slider {pad: 0.01}
        ScrollBar {orientation :vertical }
        function layout(l)
        {
            selfBox = l.genBox :mixbox, self
            ch = children.map {|x| x.layout l}
            Draw::Layout::hpack(l, selfBox, ch)
        }
    }
    HSlider {}
    Selector {layoutOpts: [:no_constraint] }
    TextBox { label: "edit" }

    function layout(l)
    {
        selfBox = l.genBox :mixerCol, self
        chBox   = []

        off = 0.0
        children.each_with_index do |ch, ind|
            weight = weights[ind]
            box    = ch.layout(l)
            l.fixed(box, selfBox, 0, off, 1.0, weight)
            off += weight
        end
        selfBox
    }
}
