Widget {
    Selector {
        layoutOpts: [:no_constraint]
        max_text: 5
    }
    ToggleButton {label: "b"; layoutOpts: [:no_constraint]}
    function layout(l, selfBox) {
        Draw::Layout::hfill(l, selfBox, children, [0.7, 0.3], 0, 2)
    }
}
