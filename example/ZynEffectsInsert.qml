Widget {
    ColorBox {
        bg: Theme::GeneralBackground

        Button   {layoutOpts: [:no_constraint]}
        Selector {layoutOpts: [:no_constraint]}
        Button   {layoutOpts: [:no_constraint]}
        Selector {layoutOpts: [:no_constraint]}
        Button   {layoutOpts: [:no_constraint]}
        Selector {layoutOpts: [:no_constraint]}
        Button   {layoutOpts: [:no_constraint]}
        Selector {layoutOpts: [:no_constraint]}
        Button   {layoutOpts: [:no_constraint]}
        Selector {layoutOpts: [:no_constraint]}
        Button   {layoutOpts: [:no_constraint]}
        Selector {layoutOpts: [:no_constraint]}
        Button   {layoutOpts: [:no_constraint]}
        Selector {layoutOpts: [:no_constraint]}

        function layout(l) {
            Draw::Layout::vpack(l, self_box(l), chBoxes(l), 0.05, 0.9, 5)
        }
        function draw(vg) {
            Draw::GradBox(vg, Rect.new(0,0,w,h))
        }
    }
    Widget {
        ZynReverb {}
        ZynEcho {}
        ZynDistortion {}
        function layout(l)
        {
            selfBox = l.genBox :eff, self
            Draw::Layout::vpack(l, selfBox, chBoxes(l))
        }

    }
    function layout(l)
    {
        selfBox = l.genBox :eff, self
        Draw::Layout::hfill(l, selfBox, chBoxes(l), [0.1, 0.9], 0, 3)
    }
}
