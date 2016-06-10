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

        function layout(l)
        {
            selfBox = l.genBox :eff, self
            Draw::Layout::vpack(l, selfBox,
            children.map {|x| x.layout l})
        }
    }
    ColorBox {
        ColorBox {
            bg: color("123456")
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
        Draw::Layout::hfill(l, selfBox, children.map {|x| x.layout l}, [0.1, 0.9])
    }
}
