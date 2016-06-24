Widget {
    //visual
    Widget {}
    Widget {
        Group {label: "general"}
        Group {label: "envelope"}
        function layout(l) {
            Draw::Layout::hpack(l, self_box(l), chBoxes(l))
        }
    }
    function layout(l) {
        Draw::Layout::vfill(l, self_box(l), chBoxes(l), [0.6, 0.4])
    }
}
