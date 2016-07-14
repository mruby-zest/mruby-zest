Button {
    id: lbut
    property Object   valueRef: nil
    property Function action:   nil
    onExtern: {
        meta = OSC::RemoteMetadata.new($remote, lbut.extern)
        lbut.tooltip = meta.tooltip
        lbut.valueRef = OSC::RemoteParam.new($remote, lbut.extern)
        lbut.valueRef.callback = lambda {|x| lbut.setValue(x)}
    }

    function setValue(x)
    {
        self.label = x
        damage_self
    }

    function onMousePress(ev) {
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
    
    function onKey(k)
    {
        puts k.ord
        if(k.ord == 8)
            self.label = self.label[0...-1]
        else
            self.label += k
        end
        whenValue.call if whenValue
        valueRef.value = self.label if valueRef
        damage_self
    }
}
