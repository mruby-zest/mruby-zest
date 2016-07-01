Button {
    id: toggle
    property Object valueRef: nil
    onExtern: {
        toggle.valueRef = OSC::RemoteParam.new($remote, toggle.extern)
        toggle.valueRef.callback = lambda {|x| toggle.setValue(x)}
    }

    function setValue(x)
    {
        self.value = x
        damage_self
    }

    function onMousePress(ev) {
        self.value = !self.value
        self.valueRef.value = self.value if self.valueRef
        damage_self
        whenValue.call if whenValue
    }

    function onMouseEnter(ev)
    {
        self.root.log(:tooltip, "extern = <" + self.extern + ">")
    }
}
