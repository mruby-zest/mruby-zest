Widget {
    Widget {
        id: title
        function draw(vg)
        {
            background Theme::GeneralBackground
        }
    }
    function onSetup(old=nil)
    {
        rows = 6
        (rows).times do |x|
            ch = Qml::ZynSendToRow.new(db)
            ch.row_id = x
            ch.cols   = rows
            Qml::add_child(self, ch)
        end
    }

    function layout(l)
    {
        selfBox = l.genBox :effvert, self
        Draw::Layout::vpack(l, selfBox, children.map {|x| x.layout l})
    }
}
