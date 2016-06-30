Widget {
    ColorBox {
        bg: Theme::GeneralBackground

        Selector {
            options: ["none", "reverb", "echo", "distortion", "phaser"]
            layoutOpts: [:no_constraint]
        }
        HSlider  {}
        Selector {
            options: ["none", "reverb", "echo", "distortion", "phaser"]
            layoutOpts: [:no_constraint]
        }
        HSlider  {}
        Selector {
            options: ["none", "reverb", "echo", "distortion", "phaser"]
            layoutOpts: [:no_constraint]
        }
        HSlider  {}
        Selector {
            options: ["none", "reverb", "echo", "distortion", "phaser"]
            layoutOpts: [:no_constraint]
        }
        HSlider  {}
        Selector {
            options: ["none", "reverb", "echo", "distortion", "phaser"]
            layoutOpts: [:no_constraint]
        }
        HSlider  {}
        Selector {
            options: ["none", "reverb", "echo", "distortion", "phaser"]
            layoutOpts: [:no_constraint]
        }
        HSlider  {}
        Selector {
            options: ["none", "reverb", "echo", "distortion", "phaser"]
            layoutOpts: [:no_constraint]
        }
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
            function class_name() { "eff" }
            function layout(l) {
                Draw::Layout::vpack(l, self_box(l), chBoxes(l))
            }

        }
        ZynSendToGrid {}
        function class_name() { "effvert" }
        function layout(l) {
            Draw::Layout::vfill(l, self_box(l), chBoxes(l), [0.6, 0.4])
        }
    }
    function class_name() { "eff" }
    function layout(l) {
        Draw::Layout::hfill(l, self_box(l), chBoxes(l), [0.1, 0.9], 0, 3)
    }
}
