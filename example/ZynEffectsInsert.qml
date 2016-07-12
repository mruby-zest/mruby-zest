Widget {
    ColorBox {
        bg: Theme::GeneralBackground

        function onSetup()
        {
            num_eff = 8
            layout = [:no_constraint]
            (0...num_eff).each do |i|
                but = Qml::Selector.new(db)
                but.layoutOpts = layout
                but.extern = "/insefx#{i}/efftype"
                sel = Qml::Selector.new(db)
                sel.layoutOpts = layout
                sel.extern = "/Pinsparts#{i}"
                Qml::add_child(self, but)
                Qml::add_child(self, sel)
            end
        }

        function layout(l) {
            Draw::Layout::vpack(l, self_box(l), chBoxes(l), 0.05, 0.9, 5)
        }
        function draw(vg) {
            Draw::GradBox(vg, Rect.new(0,0,w,h))
        }
    }
    ZynEffectGroup {
        maxeffects: 8
        extern: "/insefx"
        effects: {{0=>:reverb,
                  1=>:echo,
                  2=>:distortion,
                  3=>:eq}}

        //ZynReverb {}
        //ZynEcho {}
        //ZynDistortion {}
        //function layout(l)
        //{
        //    selfBox = l.genBox :eff, self
        //    Draw::Layout::vpack(l, selfBox, chBoxes(l))
        //}

    }
    function layout(l)
    {
        selfBox = l.genBox :eff, self
        Draw::Layout::hfill(l, selfBox, chBoxes(l), [0.1, 0.9], 0, 3)
    }
}
