Widget {
    function onSetup(old=nil)
    {
        (0...16).each do |r|
            col = Qml::ZynMixerCol.new(db)
            col.label = r.to_s
            Qml::add_child(self, col)
        end
    }

    function hpack(l, selfBox, b)
    {
        off = 0
        n = b.length
        b.each_with_index do |bb,i|
            l.fixed(bb, selfBox, off, 0, 1.0/n, 1.0)
            off += 1.0/n
        end
        selfBox
    }

    function layout(l)
    {
        selfBox = l.genBox :mixer, self
        ch = children.map {|x| x.layout l}
        hpack(l, selfBox, ch)
    }
}
