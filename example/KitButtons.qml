Widget {
    id: kit
    function onSetup(old=nil)
    {
        puts "on setup kit buttons<#{kit.w},#{kit.h}>..."
        [0,1,2,3].each do |r|
            [0,1,2,3].each do |c|
                but = createInstance("Button", self, db)
                but.label = (1+c + 4*r).to_s
                but.y = self.h*(r)/4
                but.x = self.w*(c)/4
                but.w = self.w/4
                but.h = self.h/4
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
                #if(b >= ch.length)
                #    next
                #end
                bb = ch[b].layout(l)
                b += 1
                l.sheq([bb.y, selfBox.h], [1, -(r)/4], 0)
                l.sheq([bb.x, selfBox.w], [1, -(c)/4], 0)
                l.sheq([bb.w, selfBox.w], [1, -0.25], 0)
                l.sheq([bb.h, selfBox.h], [1, -0.25], 0)
            end
        end
        selfBox
    }
}
