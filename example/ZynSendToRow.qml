Widget {
    id: row
    property Int row_id: 0
    property Int cols:   6
    TextBox {
        id: name
        bg: Theme::GeneralBackground
    }

    function draw(vg)
    {
        background Theme::ButtonInactive
    }

    function onSetup(old=nil)
    {
        name.label = (row.row_id+1).to_s + " reverb"
        (cols-row_id).times do |x|
            ch = Qml::HSlider.new(db)
            Qml::add_child(self, ch)
        end
    }

    function layout(l)
    {
        selfBox = l.genBox :zavlh, self
        chBox   = children.map {|c| c.layout l}

        step = 1/(cols+1)
        l.fixed(chBox[0], selfBox, 0, 0, step, 1)
        off = step*(1+row_id)
        (1...chBox.length).each do |bx|
            l.fixed(chBox[bx], selfBox, off, 0, step, 1)
            off += step
        end
        selfBox
    }
}
