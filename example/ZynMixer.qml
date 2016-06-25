Widget {
    function draw(vg) {
        vg.path do |v|
            v.rect(0,0,w,h)
            paint = v.linear_gradient(0,0,0,h,
            Theme::InnerGrad1, Theme::InnerGrad2)
            v.fill_paint paint
            v.fill
            v.stroke_color color(:black)
            v.stroke_width 1.0
            v.stroke
        end
    }
    function onSetup(old=nil)
    {
        (0...16).each do |r|
            col = Qml::ZynMixerCol.new(db)
            col.label = (1+r).to_s
            Qml::add_child(self, col)
        end
    }

    function class_name() { "mixer" }
    function layout(l) {
        Draw::Layout::hpack(l, self_box(l), chBoxes(l), 0.02, 0.96, 4)
    }
}
