Widget {
    id: voice_item
    property Array weights: [0.05, 0.05, 0.2, 0.2, 0.3, 0.2]

    //voice ID
    Button { label: voice_item.label; layoutOpts: [:no_constraint]}
    //channel
    TextBox { bg: Theme::GeneralBackground; label: "1" }
    //control
    TextBox { bg: Theme::GeneralBackground;  label: "0"}
    //pan
    TextBox { bg: Theme::GeneralBackground;  pad: 0; align: :left; label: "/part0/kit0/adpars/Pvolume"}
    //detune
    TextBox { bg: Theme::GeneralBackground;  label: "0"}
    //vib depth
    TextBox { bg: Theme::GeneralBackground;  label: "127"}

    function layout(l)
    {
        selfBox = l.genBox :zavlr, self
        chBox   = []

        off = 0.0
        hpad = 1/128
        children.each_with_index do |ch, ind|
            weight = weights[ind]
            box    = ch.layout(l)
            l.fixed(box, selfBox, off+hpad, 0.0, weight-2*hpad, 1.0)
            off += weight
        end
        selfBox
    }
}
