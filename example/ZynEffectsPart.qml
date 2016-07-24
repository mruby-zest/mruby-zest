Widget {
    Widget {
        function onSetup()
        {
            num_eff = 3
            (0...num_eff).each do |i|
                #TODO part id
                pid = 0
                sel = Qml::Selector.new(db)
                sel.extern = "/part#{pid}/partefx#{i}/efftype"
                but = Qml::ZynEffectBypass.new(db)
                but.children[1].extern = "/part#{pid}/Pefxbypass#{i}"
                but.children[0].extern = "/part#{pid}/Pefxroute#{i}"
                Qml::add_child(self, sel)
                Qml::add_child(self, but)
            end
        }

        function layout(l) {
            Draw::Layout::vstack(l, self_box(l), self.children)
        }

        function draw(vg) {
            Draw::GradBox(vg, Rect.new(0,0,w,h))
        }
    }
    ZynEffectGroup {
        maxeffects: 3
        extern: "/part0/partefx"
    }
    function layout(l)
    {
        selfBox = l.genBox :eff, self
        Draw::Layout::hfill(l, selfBox, chBoxes(l), [0.1, 0.9], 0, 3)
    }
}
