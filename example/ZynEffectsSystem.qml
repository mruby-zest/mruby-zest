Widget {
    ColorBox {
        bg: Theme::GeneralBackground

        function onSetup(old=nil)
        {
            return if children.length > 1
            num_eff = 4
            layout = [:no_constraint]
            (0...num_eff).each do |i|
                but = Qml::Selector.new(db)
                but.layoutOpts = layout
                but.extern = "/sysefx#{i}/efftype"
                sld = Qml::HSlider.new(db)
                sld.extern = "/Psysefxvol#{i}"
                #sel.layoutOpts = layout
                #sel.extern = "/Pinsparts#{i}"
                Qml::add_child(self, but)
                Qml::add_child(self, sld)
            end
        }

        function layout(l) {
            Draw::Layout::vpack(l, self_box(l), chBoxes(l), 0.05, 0.9, 20)
        }
        function draw(vg) {
            Draw::GradBox(vg, Rect.new(0,0,w,h))
        }
    }
    Widget {
        ZynEffectGroup {
            maxeffects: 4
            nunits:     3
            extern: "/sysefx"
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
