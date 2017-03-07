Widget {
    id: pset
    Widget {
        function onSetup(old=nil)
        {
            return if !children.empty?
            (1..16).each do |i|
                but = Qml::ToggleButton.new(self.db)
                but.label = i.to_s
                but.pad   = 1/512
                but.layoutOpts = [:no_constraint]
                but.textScale  = 0.5
                but.extern = "/part#{i-1}/Penabled"
                Qml::add_child(self, but)
            end
            (1..16).each do |i|
                but = Qml::LabelButton.new(self.db)
                but.label = "None"
                but.pad   = 1/512
                but.layoutOpts = [:no_constraint, :left_text]
                but.textScale  = 0.5
                but.extern = "/part#{i-1}/Pname"
                but.whenValue = lambda { but.root.set_view_pos(:part, i-1); but.root.change_view}
                Qml::add_child(self, but)
            end
        }

        function layout(l, selfBox) {
            Draw::Layout::vpack(l, selfBox, children[0..15],  0.0, 0.2)
            Draw::Layout::vpack(l, selfBox, children[16..31], 0.2, 0.8)
        }
    }
    Widget {
        function class_name() { "part" }
        function layout(l, selfBox) {
            Draw::Layout::vfill(l, selfBox, children, [0.4,0.3,0.3])
        }
        ZynInstrumentSettings {
            extern: pset.extern
        }
        ZynControllers {
            extern: pset.extern + "ctl/"
        }
        ZynPortamento  {
            extern: pset.extern + "ctl/"
        }
    }
    ZynScale {
        extern: "/microtonal/"
    }

    function class_name() { "part" }
    function layout(l, selfBox) {
        Draw::Layout::hfill(l, selfBox, children, [0.2,0.4,0.4])
    }
}
