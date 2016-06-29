Widget {
    id: col
    property Float spacer: 0

    function layout(l)
    {
        selfBox = l.genBox :col, col
        prev = nil
        n = col.children.length
        col.children.each do |child|
            box = child.layout l

            #Child
            l.contains(selfBox, box)

            #Centered
            l.sheq([box.x, box.w, selfBox.w],
            [1,       0.5,       -0.5], 0)

            #Ordered
            if(prev)
                l.sh([prev.y, prev.h, box.y], [1, 1, -1], -spacer)
            end
            #l.topOf(prev, box) if prev

            #Equal Spacing
            l.sh([box.h, selfBox.h], [1.0, -1/n], -spacer)

            prev = box
        end
        selfBox
    }

}
