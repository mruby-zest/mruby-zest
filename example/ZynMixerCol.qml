Widget {
    id: col
    property Array weights: [0.05, 0.1, 0.70, 0.05, 0.05, 0.05]

    Button {
        label: col.label
        layoutOpts: [:no_constraint]
    }
    TextBox {
        extern: col.extern + "Pname"
        bg: nil
        height: 0.4
        label: "synth"
    }
    ColorBox {
        bg: Theme::GeneralBackground
        Slider {visual: true; centered: false; pad: 0.01}
        Slider {visual: true; centered: false; pad: 0.01}
        ScrollBar {}
        function class_name() { "mixbox" }
        function layout(l) {
            Draw::Layout::hpack(l, self_box(l), chBoxes(l))
        }
    }
    HSlider {
        extern: col.extern + "Ppanning"
        label: "pan"
    }
    Selector {
        extern: col.extern + "Prcvchn"
        layoutOpts: [:no_constraint]
    }
    Button { layoutOpts: [:no_constraint]; label: "edit" }

    function layout(l)
    {
        selfBox = l.genBox :mixerCol, self
        chBox   = []

        off = 0.0
        fixed_pad = 2
        children.each_with_index do |ch, ind|
            weight = weights[ind]
            box    = ch.layout(l)
            l.fixed_long(box, selfBox, 0, off, 1.0, weight,
                         0, fixed_pad, 0, -2*fixed_pad)
            off += weight
        end
        selfBox
    }

    function onSetup(old=nil)
    {
        children.each do |ch|
            ch.extern()
        end
    }
}
