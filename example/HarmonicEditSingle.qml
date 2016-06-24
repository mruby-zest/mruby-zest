ColorBox {
    property Function whenValue: nil
    property Int      num: 0
    property Symbol   slidetype: nil
    id: hes
    bg: nil

    function cb()
    {
        whenValue.call if whenValue
    }

    Slider {
        value: 0.5
        pad: 0
        extern: {
            if(hes.slidetype == :oscil)
                hes.extern + "magnitude" + hes.num.to_s
            else
                hes.extern + "Phmag" + hes.num.to_s
            end
        }
        whenValue: lambda {hes.cb}
    }
    Text {
        layoutOpts: [:ignoreAspect]
        height: 1.0
        label: hes.num.to_s
    }

    Slider {
        value: 0.5
        pad: 0
        extern: {
            if(hes.slidetype == :oscil)
                hes.extern + "phase" + hes.num.to_s
            else
                hes.extern + "Phrelbw" + hes.num.to_s
            end
        }
        whenValue: lambda {hes.cb}
    }

    function layout(l)
    {
        selfBox = l.genBox :harmonicEdit, self
        chBox   = children.map {|x| x.layout l}
        l.fixed(chBox[0], selfBox, 0.0, 0.00, 1.0, 0.47)
        l.fixed(chBox[1], selfBox, 0.0, 0.48, 1.0, 0.08)
        l.fixed(chBox[2], selfBox, 0.0, 0.57, 1.0, 0.43)
        selfBox
    }
}
