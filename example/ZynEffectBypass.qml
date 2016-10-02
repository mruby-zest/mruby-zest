Widget {
    Selector {
        layoutOpts: [:no_constraint]
        max_text: 5
    }
    ToggleButton {label: "b"; layoutOpts: [:no_constraint]}
    function layout(l) {
        Draw::Layout::hfill(l, self_box(l), chBoxes(l), [0.7, 0.3], 0, 2)
    }
}
