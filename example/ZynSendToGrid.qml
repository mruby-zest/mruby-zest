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
                ch.cols   = rows
                Qml::add_child(self, ch)
            end
        }

        function class_name() { "send_to_grid" }

        function layout(l) {
            Draw::Layout::vpack(l, self_box(l), chBoxes(l))
        }
    }
    function draw(vg) {
        Draw::GradBox(vg, Rect.new(0,0,w,h))
    }

    function layout(l) {
        selfBox = self_box l
        chBox   = children[0].layout(l)
        pad = 4
        l.fixed_long(chBox, selfBox, 0, 0, 1, 1,
        pad, pad, -2*pad, -2*pad)
        selfBox
    }
}
