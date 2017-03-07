Widget {
    id: indent
    property Unused pad: 2;

    function class_name() { "Indent" }
    function layout(l, selfBox)
    {
        return selfBox if children.empty?

        child = self.children[0]

        chBox = l.genConstBox(pad, pad,
                selfBox.w-2*pad, selfBox.h-2*pad, child)
        child.layout(l, chBox)
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
