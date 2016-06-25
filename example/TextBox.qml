ColorBox {
    id: textBox
    pad: 0.003
    bg:  nil
    property Float height: 0.7
    property Symbol align: :center
    Text {
        label:      textBox.label
        height:     textBox.height
        layoutOpts: [:no_constraint]
        align:      textBox.align
    }
}
