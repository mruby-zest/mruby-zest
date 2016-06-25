Widget {
    ColorBox {
        bg: Theme::GeneralBackground

        Selector {layoutOpts: [:no_constraint]}
        HSlider  {}
        Selector {layoutOpts: [:no_constraint]}
        HSlider  {}
        Selector {layoutOpts: [:no_constraint]}
        HSlider  {}
        Selector {layoutOpts: [:no_constraint]}
        HSlider  {}
        Selector {layoutOpts: [:no_constraint]}
        HSlider  {}
        Selector {layoutOpts: [:no_constraint]}
        HSlider  {}
        Selector {layoutOpts: [:no_constraint]}
        HSlider  {}

        function layout(l) {
            Draw::Layout::vpack(l, self_box(l), chBoxes(l), 0.05, 0.9, 5)
        }
        function draw(vg) {
            Draw::GradBox(vg, Rect.new(0,0,w,h))
        }
    }
    Widget {
        Widget {
            ZynReverb {}
            ZynEcho {}
            ZynDistortion {}
            function layout(l)
            {
                selfBox = l.genBox :eff, self
                Draw::Layout::vpack(l, selfBox,
                    children.map {|x| x.layout l})
            }

        }
        ZynSendToGrid {}
        function layout(l)
        {
            selfBox = l.genBox :effvert, self
            Draw::Layout::vfill(l, selfBox, children.map {|x| x.layout l}, [0.6, 0.4])
        }
    }
    function layout(l)
    {
        selfBox = l.genBox :eff, self
        Draw::Layout::hfill(l, selfBox, children.map {|x| x.layout l}, [0.1, 0.9], 0, 3)
    }
}
