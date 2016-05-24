Widget {
    id: col

    function layout(l)
    {
        selfBox = l.genBox :col, col
        prev = nil
        N = col.children.length
        col.children.each do |child|
            box = child.layout l

            #Child
            l.contains(selfBox, box)

            #Centered
            l.sheq([box.x, box.w, selfBox.w],
            [1,       0.5,       -0.5], 0)

            #Ordered
            l.topOf(prev, box) if prev

            #Equal Spacing
            l.sheq([box.h, selfBox.h], [1.0, -1/N], 0)

            prev = box
        end
        selfBox
    }

}
