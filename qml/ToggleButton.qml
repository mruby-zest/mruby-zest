Button {
    id: toggle
    property Object valueRef: nil
    onExtern: {
        meta = OSC::RemoteMetadata.new($remote, toggle.extern)
        toggle.label   = meta.short_name if toggle.label.empty?
        toggle.tooltip = meta.tooltip
        toggle.valueRef.clean if toggle.valueRef
        toggle.valueRef = OSC::RemoteParam.new($remote, toggle.extern)
        toggle.valueRef.callback = lambda {|x| toggle.setValue(x)}
    }

    function setValue(x)
    {
        self.value = x
        whenValue.call if whenValue
        damage_self
    }

    function refresh() {
        self.valueRef.refresh if self.valueRef
    }

    function onMousePress(ev) {
        self.value = !self.value
        self.valueRef.value = self.value if self.valueRef
        damage_self
        whenValue.call if whenValue
    }

    function onMouseEnter(ev)
    {
        if(self.tooltip.nil? || self.tooltip.empty?)
            self.root.log(:tooltip, "extern = <" + self.extern + ">")
        else
            self.root.log(:tooltip, self.tooltip)
        end
    }
}
