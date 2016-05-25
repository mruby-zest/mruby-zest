Widget {
    id: indent

    function class_name() { "Indent" }
    function layout(l)
    {
        selfBox = l.genBox :indent, indent
        if(!indent.children.empty?)
            ch = indent.children[0].layout l
            pad = 1/32
            l.fixed(ch, selfBox, pad, pad, 1-2*pad, 1-2*pad)
            #l.contains selfBox, ch
        end
        selfBox
    }

    function draw(vg) { 
        indent_color = color("232C36")
        vg.path do |v|
            v.rounded_rect(0, 0, w, h, 3)
            v.fill_color indent_color
            v.fill
        end
    }
}
