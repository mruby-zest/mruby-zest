ColorBox {
    property Function whenValue: nil
    property Int      num: 0
    property Symbol   type: nil
    id: hes
    bg: Theme::GeneralBackground
    pad: 0.0

    function cb()
    {
        whenValue.call if whenValue
    }

    Slider {
        id: a
        value: 0.5
        extern: {
            if(hes.type == :oscil)
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
        id: b
        layoutOpts: [:ignoreAspect]
        height: 1.2
        label: hes.num.to_s
    }

    Slider {
        id: c
        value: 0.5
        extern: {
            if(hes.type == :oscil)
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
        aaaaBox = a.layout(l)
        bbbbBox = b.layout(l)
        ccccBox = c.layout(l)
        l.fixed(aaaaBox, selfBox, 0.0, 0.00, 1.0, 0.45)
        l.fixed(bbbbBox, selfBox, 0.0, 0.45, 1.0, 0.10)
        l.fixed(ccccBox, selfBox, 0.0, 0.55, 1.0, 0.45)
        selfBox
    }
}
