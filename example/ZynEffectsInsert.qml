Widget {
    ColorBox {
        bg: Theme::GeneralBackground

        function onSetup()
        {
            num_eff = 8
            (0...num_eff).each do |i|
                but = Qml::Selector.new(db)
                but.extern = "/insefx#{i}/efftype"
                but.active = false
                sel = Qml::Selector.new(db)
                sel.whenValue = lambda { but.active = sel.selected != 1; but.damage_self }
                sel.extern = "/Pinsparts#{i}"
                Qml::add_child(self, but)
                Qml::add_child(self, sel)
            end
        }

        function layout(l) {
            Draw::Layout::vstack(l, self_box(l), self.children, 5)
        }
        function draw(vg) {
            Draw::GradBox(vg, Rect.new(0,0,w,h))
        }
    }
    ZynEffectGroup {
        maxeffects: 8
        extern: "/insefx"
    }
    function layout(l)
    {
        selfBox = l.genBox :eff, self
        Draw::Layout::hfill(l, selfBox, chBoxes(l), [0.1, 0.9], 0, 3)
    }
}
