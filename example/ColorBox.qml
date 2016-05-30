Widget {
    property Color bg: color("8f600f")
    property Float pad: 0.0
    function draw(vg)
    {
        pad2 = (1-2*pad)
        vg.path do |v|
            v.rect(pad*w,pad*h,pad2*w,pad2*h)
            v.fill_color self.bg
            v.fill
        end
    }
    
    function layout(l)
    {
        selfBox = l.genBox :colorBox, self
        prev = nil
        N = self.children.length
        self.children.each do |child|
            box = child.layout l

            #Child
            l.contains(selfBox, box)

            next if(!layoutOpts.include?(:think_of_the_children))
            #Centered
            #l.sheq([box.x, box.w, selfBox.w],
            #[0.5,       1.0,       -1.0], 0)

            #Ordered
            l.topOf(prev, box) if prev

            #Equal Spacing
            #l.sh([box.h, selfBox.h], [1.0, -1/N], 0)

            prev = box
        end
        selfBox
    }
}
