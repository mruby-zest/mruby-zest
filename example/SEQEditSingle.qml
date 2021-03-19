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
        type: "f"
        extern: {
            hes.extern + "sequence" + hes.num.to_s
        }
        whenValue: lambda {hes.cb}

        function onSetup(old=nil) {
            undef :onMousePress if self.respond_to?(:onMousePress)
            undef :onMouseMove  if self.respond_to?(:onMouseMove)
        }
    }
    Text {
        layoutOpts: [:ignoreAspect]
        height: 1.0
        label: (1+hes.num).to_s
    }

    function layout(l, selfBox)
    {
        children[0].fixed(l, selfBox, 0.0, 0.00, 1.0, 0.94)
        children[1].fixed(l, selfBox, 0.0, 0.95, 1.0, 0.05)
        selfBox
    }

    function onSetup(v=nil)
    {
        children.each do |c|
            c.extern()
        end
    }
}
