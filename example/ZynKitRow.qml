Widget {
    id: kit_item
    property Array weights: [0.05, 0.10, 0.10, 0.10, 0.05, 0.10, 0.10, 0.10, 0.30]

    Button { label: kit_item.label; layoutOpts: [:no_constraint]}
    TextBox { label: "kit name" }
    HSlider { label: "0"}
    //TODO replace with a button trio
    Button  { layoutOpts: [:no_constraint]; }
    HSlider {}
    FancyButton { layoutOpts: [:no_constraint]; label: "edit" }
    FancyButton { layoutOpts: [:no_constraint]; label: "edit" }
    FancyButton { layoutOpts: [:no_constraint]; label: "edit" }
    Selector { layoutOpts: [:no_constraint]; label: "off" }

    function layout(l)
    {
        selfBox = l.genBox :kitrow, self
        chBox   = children.map {|x| x.layout l}
        Draw::Layout::hfill(l, selfBox, chBox, kit_item.weights, 0, 3)
    }
}
