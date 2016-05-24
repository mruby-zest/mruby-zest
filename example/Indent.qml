Widget {
    id: indent

    function class_name() { "Indent" }
    function layout(l)
    {
        selfBox = l.genBox :indent, indent
        if(!indent.children.empty?)
            ch = indent.children[0].layout l
            l.contains selfBox, ch
        end
        selfBox
    }

    function draw(vg) { 
        vg.path do |v|
            v.rounded_rect(0, 0, w, h, 10)
            v.fill_color(NVG.rgba(9, 0, 0, 255))
            v.fill
        end
    }
}
