Widget {
    Button {layoutOpts: [:no_constraint]}
    Button {label: "b"; layoutOpts: [:no_constraint]}
    function layout(l) {
        Draw::Layout::hpack(l, self_box(l), chBoxes(l), 0.00, 1.0, 3)
    }
}
