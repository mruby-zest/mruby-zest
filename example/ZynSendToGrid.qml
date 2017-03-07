Widget {
    Widget {
        Widget {
            id: title
        }
        function onSetup(old=nil)
        {
            return if children.length > 1
            rows = 4
            (rows).times do |x|
                ch = Qml::ZynSendToRow.new(db)
                ch.row_id = x
                ch.cols   = 3
                Qml::add_child(self, ch)
            end
        }

        function class_name() { "send_to_grid" }

        function layout(l, selfBox) {
            Draw::Layout::vpack(l, selfBox, children)
        }
    }
    function draw(vg) {
        Draw::GradBox(vg, Rect.new(0,0,w,h))
    }

    function layout(l, selfBox) {
        pad = 4
        children[0].fixed_long(l, selfBox, 0, 0, 1, 1,
        pad, pad, -2*pad, -2*pad)
        selfBox
    }
}
