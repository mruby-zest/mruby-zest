Widget {
    id: kitbuttons
    property Int rows: 4
    property Symbol sym: nil
    function onSetup(old=nil)
    {
        (0...rows).each do |r|
            [0,1,2,3].each do |c|
                ii         = (1+c + 4*r)
                but        = Qml::KitButton.new(db)
                but.label  = ii.to_s
                but.action = lambda {kitbuttons.change_active(ii-1)}
                Qml::add_child(self, but)
            end
        end
    }

    function change_active(ii)
    {
        root.set_view_pos(self.sym,ii) if self.sym

        children.each_with_index do |ch, i|
            n = (i == ii)
            if(n != ch.value)
                ch.value = n
                ch.damage_self
            end
        end
    }

    function layout(l)
    {
        selfBox = l.genBox :kitButtons, self
        b = 0
        cols = 4
        ch = self.children
        (0...rows).each do |r|
            (0...cols).each do |c|
                bb = ch[b].layout(l)
                b += 1
                l.fixed(bb, selfBox, c/4, r/self.rows, 0.25, 1/self.rows)
            end
        end
        l.aspect(selfBox, rows, cols)
        selfBox
    }

    function animate()
    {
        return if !self.sym
        vv = root.get_view_pos self.sym
        children.each_with_index do |ch, i|
            n = (i == vv)
            if(n != ch.value)
                ch.value = n
                ch.damage_self
            end
        end
    }
}
