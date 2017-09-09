Widget {
    Widget {
        function onSetup(old=nil) {
            Theme.constants.each do |c|
                ch = Qml::ColorButton.new(db)
                ch.label = c.to_s
                ch.bg_color = Theme.const_get(c)
                Qml::add_child(self, ch)
            end
        }

        function layout(l, selfBox) {
            Draw::Layout::grid(l, selfBox, children, 8, 6)
        }
    }
    Widget {
        ColorSel{}
    }

    function layout(l, selfBox) {
        Draw::Layout::vfill(l, selfBox, children, [0.60, 0.40])
    }
}
