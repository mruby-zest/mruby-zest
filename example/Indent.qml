Widget {
    id: indent
    property Float pad: 1/32

    function class_name() { "Indent" }
    function layout(l)
    {
        selfBox = l.genBox :indent, indent
        if(!indent.children.empty?)
            ch = indent.children[0].layout l
            #l.fixed(ch, selfBox, pad, pad, 1-2*pad, 1-2*pad)
            l.contains selfBox, ch
            l.sh([ch.w, ch.x, selfBox.w], [+1, +1, -1], -3)
            l.sh([ch.h, ch.y, selfBox.h], [+1, +1, -1], -3)

            l.sheq([ch.x, ch.w, selfBox.w],
                [2, 1, -1], 0)
            l.sheq([ch.y, ch.h, selfBox.h],
                [2, 1, -1], 0)
        end
        selfBox
    }

    function draw(vg) {
        indent_color = color("232C36")
        vg.path do |v|
            v.rounded_rect(0, 0, w, h, 3)
            v.fill_color Theme::VisualBackground
            v.fill
        end
    }
}
