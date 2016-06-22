ColorBox {
    property Function whenValue: nil
    property Int      num: 0
    property Symbol   slidetype: nil
    id: hes
    bg: Theme::GeneralBackground
    pad: 0.0

    function cb()
    {
        whenValue.call if whenValue
    }

    Slider {
        value: 0.5
        extern: {
            if(hes.slidetype == :oscil)
                hes.extern + "magnitude" + hes.num.to_s
            else
                hes.extern + "Phmag" + hes.num.to_s
            end
        }
        whenValue: lambda {hes.cb}
        //pad: 0.2
        //bg: color("827744")
    }
    Text {
        layoutOpts: [:ignoreAspect]
        height: 1.2
        label: hes.num.to_s
    }

    Slider {
        value: 0.5
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
        aaaaBox = children[0].layout(l)
        bbbbBox = children[1].layout(l)
        ccccBox = children[2].layout(l)
        l.fixed(aaaaBox, selfBox, 0.0, 0.00, 1.0, 0.45)
        l.fixed(bbbbBox, selfBox, 0.0, 0.45, 1.0, 0.10)
        l.fixed(ccccBox, selfBox, 0.0, 0.55, 1.0, 0.45)
        selfBox
    }
}
