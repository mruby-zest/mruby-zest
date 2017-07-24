Widget {
    id: col
    property Array weights: [0.05, 0.95, 0.05, 0.05, 0.05]

    function rap2dB(x) { 20*Math::log10(x) }
    function bound(x)  { [0.0, [1.0, x].min].max }
    function cv(x)     {min_db = -40;bound((min_db-rap2dB(x))/min_db)}

    function set_level(l,r)
    {
        old = children[1].children[1].value
        if(old != cv(l))
            children[1].children[1].value = cv(l)
            children[1].children[0].value = cv(r)
            children[1].children[0].damage_self
            children[1].children[1].damage_self
        end
    }

    TextBox {
        label: "Master"
    }

    ColorBox {
        bg: Theme::GeneralBackground
        Slider {visual: true; centered: false; pad: 0.01}
        Slider {visual: true; centered: false; pad: 0.01}
        Slider {
            extern: "/Pvolume"
            centered: false
            pad: 0.01
        }
        function class_name() { "mixbox" }
        function layout(l,selfBox) {
            Draw::Layout::hpack(l, selfBox, children)
        }
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
