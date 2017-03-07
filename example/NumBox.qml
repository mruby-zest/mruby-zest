ColorBox {
    id: numBox
    pad: 0.003
    bg:  nil
    property Float height: 0.7
    property Symbol align: :center
    property Object valueRef: nil
    Text {
        label:      ""
        height:     numBox.height
        layoutOpts: [:no_constraint]
        align:      numBox.align
    }

    onExtern: {
        ref = OSC::RemoteParam.new($remote, numBox.extern)
        ref.mode     = :full
        ref.callback = lambda {|x|
            numBox.children[0].label = (((10*x).to_i)/10).to_s;
            numBox.damage_self
        }
        numBox.valueRef = ref
    }
    
    function layout(l, selfBox)
    {
        return selfBox if layoutOpts.include?(:free)

        #Assume all digit bounding boxes are roughly the same
        scale = 100
        $vg.font_size scale
        bb = $vg.text_bounds(0, 0, " 0.12 ")
        l.aspect(selfBox, bb, scale)
        children[0].fixed(l, selfBox, 0, 0, 1, 1)

        selfBox
    }
}
