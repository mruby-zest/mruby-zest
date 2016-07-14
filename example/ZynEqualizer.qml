Widget {
    VisEq {}
    Widget {}
    function draw(vg) {
        Draw::GradBox(vg, Rect.new(0, 0, w, h))
    }

    function layout(l) {
        Draw::Layout::hpack(l, self_box(l), chBoxes(l))
    }

}
