Widget {
    id: col
    property Array weights: [0.05, 0.1, 0.70, 0.05, 0.05, 0.05]
    property Int   idx: 0

    function set_level(l)
    {
        old = children[2].children[0].value
        if(old != l)
            children[2].children[0].value = l
            children[2].children[1].value = l
            children[2].children[0].damage_self
            children[2].children[1].damage_self
        end
    }

    ToggleButton {
        extern: col.extern + "Penabled"
        label: col.label
        layoutOpts: [:no_constraint]
    }
    TextEdit {
        extern: col.extern + "Pname"
        height: 0.333333
        label: "synth"
    }
    ColorBox {
        bg: Theme::GeneralBackground
        Slider {visual: true; centered: false; pad: 0.01}
        Slider {visual: true; centered: false; pad: 0.01}
        Slider {
            extern: col.extern + "Pvolume"
            centered: false
            pad: 0.01
        }
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
    TriggerButton {
        layoutOpts: [:no_constraint];
        label: "edit"
        whenValue: lambda { col.root.set_view_pos(:part, idx) }
    }

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
