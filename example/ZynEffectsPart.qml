Widget {
    id: base
    Widget {
        function onSetup()
        {
            num_eff = 3
            (0...num_eff).each do |i|
                #TODO part id
                sel = Qml::Selector.new(db)
                sel.extern = base.extern+"partefx#{i}/efftype"
                but = Qml::ZynEffectBypass.new(db)
                but.children[1].extern = base.extern+"Pefxbypass#{i}"
                but.children[0].extern = base.extern+"Pefxroute#{i}"
                Qml::add_child(self, sel)
                Qml::add_child(self, but)
            end
        }

        function layout(l, selfBox) {
            Draw::Layout::vstack(l, selfBox, children)
        }

        function draw(vg) {
            Draw::GradBox(vg, Rect.new(0,0,w,h))
        }
    }
    ZynEffectGroup {
        maxeffects: 3
        extern: base.extern + "partefx"
    }

    function layout(l, selfBox) {
        Draw::Layout::hfill(l, selfBox, children, [0.1, 0.9], 0, 3)
    }
}
