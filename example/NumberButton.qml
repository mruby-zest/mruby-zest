Widget {
    id: num
    property Function whenValue: nil
    property Bool     value:     false
    property Int      number:       0
    function class_name() { "NumButton" }


    function cb()
    {
        whenValue.call if whenValue
    }

    function onMousePress(ev) {
        self.value = !self.value
        damage_self
        cb()
    }

    onLabel: {
        but.label = num.label
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
        whenValue:  lambda { num.cb }
        layoutOpts: [:no_constraint]
    }

    Button {
        id: pow
        label: num.number.to_s
        pad: 0
        whenValue:  lambda { num.cb }
        layoutOpts: [:no_constraint]
    }

}
