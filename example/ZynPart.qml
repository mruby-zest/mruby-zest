Widget {
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
                but.whenValue = lambda { but.root.set_view_pos(:part, i-1) }
                Qml::add_child(self, but)
            end
        }

        function layout(l)
        {
            selfBox = l.genBox :part, self
            rows = chBoxes(l)
            Draw::Layout::vpack(l, selfBox, rows[0..15],  0.0, 0.2)
            Draw::Layout::vpack(l, selfBox, rows[16..31], 0.2, 0.8)
        }
    }
    Widget {
        id: ppars
        extern: "/part0/"
        function class_name() { "part" }
        function layout(l) {
            Draw::Layout::vfill(l, self_box(l), chBoxes(l), [0.4,0.3,0.3])
        }
        ZynInstrumentSettings {
            extern: ppars.extern
        }
        ZynControllers {
            extern: ppars.extern + "ctl/"
        }
        ZynPortamento  {
            extern: ppars.extern + "ctl/"
        }
    }
    ZynScale { }

    function class_name() { "part" }
    function layout(l) {
        Draw::Layout::hfill(l, self_box(l), chBoxes(l), [0.2,0.4,0.4])
    }
}
