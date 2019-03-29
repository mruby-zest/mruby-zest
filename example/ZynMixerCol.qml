Widget {
    id: col
    property Array weights: [0.05, 0.1, 0.70, 0.05, 0.05, 0.05]
    property Int   idx: 0

    function rap2dB(x) { 20*Math::log10(x) }
    function bound(x)  { [0.0, [1.0, x].min].max }
    function cv(x)     {min_db = -40;bound((min_db-rap2dB(x))/min_db)}

    function set_level(l,r)
    {
        old = children[2].children[0].value
        if(old != cv(l))
            children[2].children[0].value = cv(l)
            children[2].children[0].damage_self
        end

        old = children[2].children[1].value
        if(old != cv(r))
            children[2].children[1].value = cv(r)
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
            type: :float
            extern: col.extern + "Volume"
            centered: false
            pad: 0.01
        }
        function class_name() { "mixbox" }
        function layout(l, selfBox) {
            Draw::Layout::hpack(l, selfBox, children)
        }
    }
    HSlider {
        extern: col.extern + "Ppanning"
        centered: true;
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

    function layout(l, selfBox) {
        off = 0.0
        fixed_pad = 2
        children.each_with_index do |ch, ind|
            weight = weights[ind]
            l.fixed_long(ch, selfBox, 0, off, 1.0, weight,
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
