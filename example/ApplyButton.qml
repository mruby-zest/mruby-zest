Button {
    id: app
    BusyLoop {
        id: lp
    }
    function onMousePress(ev) {
        self.value = 1.0
        whenValue.call if whenValue
        lp.spin = true
        damage_self
    }
    
    property Object valueRef: nil
    onExtern: {
        app.valueRef = OSC::RemoteParam.new($remote, app.extern)
        app.valueRef.callback = lambda {|x| app.setValue(x)}
    }

    function setValue(x)
    {
        self.value = x
        lp.spin = false if x == false
        lp.damage_self
        damage_self
    }

    function animate()
    {
        return if self.value == 0
        return if self.value == false
        return if self.value == true
        self.value *= 0.7
        self.value  = 0 if self.value < 0.02
        damage_self
    }
    

    function layout(l)
    {
        t = widget.class_name.to_sym
        selfBox = l.genBox t, button
        bx = lp.layout(l)
        l.sheq([selfBox.w, bx.w], [-0.2, 1.0], 0)
        l.sh([selfBox.h, bx.h], [-1.0, 1.0], 0)
        l.sheq([bx.x], [1.0], 5)
        l.contains(selfBox, bx)
        selfBox
    }


}
