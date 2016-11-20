Widget {
    id: row
    property Int row_id: 0
    property Int cols:   4
    TextSel {
        id: name
        extern: "/sysefx#{row.row_id}/efftype"
    }

    function onSetup(old=nil)
    {
        return if children.length > 1
        name.label = (row.row_id+1).to_s + " reverb"
        (cols-row_id).times do |x|
            ch = Qml::HSlider.new(db)
            ch.extern = "/sysefxfrom#{row_id}/to#{x+row_id+1}"
            ch.tooltip = "Route from system effect #{row_id+1} to effect #{x+row_id+2}"
            Qml::add_child(self, ch)
        end
    }

    function layout(l)
    {
        selfBox = l.genBox :zavlh, self
        chBox   = chBoxes(l)

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
