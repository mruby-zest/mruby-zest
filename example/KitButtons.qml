Widget {
    id: kit
    function onSetup(old=nil)
    {
        puts "on setup kit buttons<#{kit.w},#{kit.h}>..."
        [0,1,2,3].each do |r|
            [0,1,2,3].each do |c|
                but = createInstance("KitButton", self, db)
                but.label = (1+c + 4*r).to_s
            end
        end
    }

    function layout(l)
    {
        puts("kitlayout...")
        selfBox = l.genBox :kitButtons, self
        b = 0
        ch = self.children
        [0,1,2,3].each do |r|
            [0,1,2,3].each do |c|
                bb = ch[b].layout(l)
                b += 1
                l.fixed(bb, selfBox, c/4, r/4, 0.25, 0.25)
            end
        end
        selfBox
    }
}
