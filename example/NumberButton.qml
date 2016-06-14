Widget {
    id: num
    property Function whenClick: nil
    property Bool     value:     false
    property Int      number:       0
    function class_name() { "NumButton" }

    function onMousePress(ev) {
        self.value = !self.value
        if(root)
            root.damage_item self
        end
        self.whenClick.call if self.whenClick
    }

    function layout(l)
    {
        selfBox = l.genBox :numButton, self
        buttBox = l.genBox :numButtont, children[0]
        numbBox = l.genBox :numButtonn, children[1]
        l.contains(selfBox, buttBox)
        l.contains(selfBox, numbBox)
        l.rightOf(numbBox, buttBox)
        l.aspect(numbBox, 1.0, 1.0)
        #l.fixed(buttBox, selfBox, 0, 0, 0.25, 1)
        #l.fixed(buttBox, selfBox, 0, 0, 0.25, 1)
        selfBox
    }
    Button {
        id: but
        pad: 0
        label: num.label
        layoutOpts: [:no_constraint]
    }

    Button {
        id: pow
        label: num.number.to_s
        pad: 0
        layoutOpts: [:no_constraint]
    }

}
