Widget {
    property Array weights: [0.1, 0.1, 0.5, 0.1, 0.1, 0.1]

    TextBox { label: "1" }
    TextBox { label: "synth" }
    ColorBox { bg: color("00ff00") }
    ColorBox { bg: color("ff00ff") }
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
