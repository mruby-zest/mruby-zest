Widget {
    id: kit
    property Int rows: 4
    function onSetup(old=nil)
    {
        #puts "on setup kit buttons<#{kit.w},#{kit.h}>..."
        (0...rows).each do |r|
            [0,1,2,3].each do |c|
                but = Qml::KitButton.new(db)
                but.label = (1+c + 4*r).to_s
                Qml::add_child(self, but)
            end
        end
    }

    function layout(l)
    {
        #puts("kitlayout...")
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
}
