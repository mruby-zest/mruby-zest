ColorBox {
    id: textBox
    pad: 0.003
    bg:  nil
    property Float height: 0.7
    Text {
        label:      textBox.label
        height:     textBox.height
        layoutOpts: [:no_constraint]
    }
}
