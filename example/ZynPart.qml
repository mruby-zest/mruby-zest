Widget {
    Widget {
        function onSetup(old=nil)
        {
            return if !children.empty?
            (1..16).each do |i|
                but = Qml::Button.new(self.db)
                but.label = i.to_s
                but.pad   = 1/512
                but.layoutOpts = [:no_constraint]
                but.textScale  = 0.5
                Qml::add_child(self, but)
            end
            (1..16).each do |i|
                but = Qml::Button.new(self.db)
                but.label = "None"
                but.pad   = 1/512
                but.layoutOpts = [:no_constraint, :left_text]
                but.textScale  = 0.5
                Qml::add_child(self, but)
            end
        }

        function layout(l)
        {
            selfBox = l.genBox :part, self
            rows = children.map {|x| x.layout l}
            Draw::Layout::vpack(l, selfBox, rows[0..15],  0.0, 0.2)
            Draw::Layout::vpack(l, selfBox, rows[16..31], 0.2, 0.8)
        }
    }
    Widget {
        function layout(l)
        {
            selfBox = l.genBox :part, self
            rows = children.map {|x| x.layout l}
            Draw::Layout::vfill(l, selfBox, rows, [0.4,0.3,0.3])
        }
        ZynInstrumentSettings {}
        ZynControllers {}
        ZynPortamento  {}
    }
    ZynScale {
    }

    function layout(l)
    {
        selfBox = l.genBox :part, self
        cols = children.map {|x| x.layout l}
        Draw::Layout::hfill(l, selfBox, cols, [0.2,0.4,0.4])
    }
}
