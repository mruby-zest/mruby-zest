ColorBox {
    id: textBox
    pad: 0.003
    property Float height: 0.5
    Text {
        label:      textBox.label
        height:     textBox.height
        layoutOpts: [:no_constraint]
    }
}
