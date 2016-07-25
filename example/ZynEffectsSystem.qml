Widget {
    ColorBox {
        bg: Theme::GeneralBackground

        function onSetup(old=nil)
        {
            return if children.length > 1
            num_eff = 4
            prt = root.get_view_pos(:part)
            (0...num_eff).each do |i|
                but = Qml::Selector.new(db)
                but.extern = "/sysefx#{i}/efftype"
                sld = Qml::HSlider.new(db)
                sld.extern = "/Psysefxvol#{i}/part#{prt}"
                Qml::add_child(self, but)
                Qml::add_child(self, sld)
            end
        }

        function layout(l) {
            Draw::Layout::vstack(l, self_box(l), self.children)#, 0.05, 0.9, 20)
        }
        function draw(vg) {
            Draw::GradBox(vg, Rect.new(0,0,w,h))
        }
    }
    Widget {
        ZynEffectGroup {
            maxeffects: 4
            nunits:     4
            extern: "/sysefx"
        }
        ZynSendToGrid {}
        function class_name() { "effvert" }
        function layout(l) {
            Draw::Layout::vfill(l, self_box(l), chBoxes(l), [0.666, 0.333])
        }
    }
    function class_name() { "eff" }
    function layout(l) {
        Draw::Layout::hfill(l, self_box(l), chBoxes(l), [0.1, 0.9], 0, 3)
    }

    function set_view()
    {
        prt = root.get_view_pos(:part)
        ch = children[0].children
        n  = ch.length/2
        (0...n).each do |i|
            ch[2*i+1].extern = "/Psysefxvol#{i}/part#{prt}"
        end
    }
}
