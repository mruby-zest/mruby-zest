Widget {
    id: forms
    Text {
        label: forms.label
    }

    function draw(vg) {
        vg.path do |v|
            v.rect(0,0,w,h)
            paint = v.linear_gradient(0,0,0,h,
            Theme::ModuleGrad1, Theme::ModuleGrad2)
            v.fill_paint paint
            v.fill
            v.stroke_color(color("000000"))
            v.stroke
        end
    }
    function onSetup(old=nil) {
        return if @setup_done
        children[1..-1].each do |c|
            ch = Qml::TextBox.new(db)
            ch.label = c.tooltip
            ch.align = :left
            Qml::add_child(self, ch)
        end
        @setup_done = true
    }
    function layout(l, selfBox) {
        n = (children.length + 1)/2

        l.fixed_long(children[0], selfBox,
            0, 0, 1, 1/n,
            0, 0, 0, 0)
        (1...n).each do |i|
            l.fixed_long(children[i+n-1], selfBox,
                0, i/n, 0.75, 0.5/n, 
                10, 0, 0, 0)
            l.fixed_long(children[i], selfBox,
                0.25, (i+0.5)/n, 0.75, 0.5/n, 
                0, 0, -10, 0)
        end
    }
}
