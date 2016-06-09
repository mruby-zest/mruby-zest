Widget {
    function onSetup(old=nil)
    {
        (0...16).each do |r|
            col = Qml::ZynMixerCol.new(db)
            col.label = r.to_s
            Qml::add_child(self, col)
        end
    }

    function layout(l)
    {
        selfBox = l.genBox :mixer, self
        ch = children.map {|x| x.layout l}
        Draw::Layout::hpack(l, selfBox, ch)
    }
}
