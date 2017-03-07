ColorBox {
    id: textBox
    pad: 0.003
    bg:  nil
    property Float height: 0.7
    property Symbol align: :center
    property Object valueRef: nil
    Text {
        label:      textBox.label
        height:     textBox.height
        layoutOpts: [:no_constraint]
        align:      textBox.align
    }

    onExtern: {
        ref = OSC::RemoteParam.new($remote, textBox.extern)
        ref.callback = lambda {|x|
            textBox.label = x;
            textBox.damage_self
        }
        textBox.valueRef = ref
    }

    function layout(l, selfBox) {
        children[0].fixed(l, selfBox, 0, 0, 1, 1)
        selfBox
    }
}
