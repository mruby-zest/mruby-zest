Widget {
    id: valuator
    property Object valueRef: nil;
    property Object prev:     nil;

    property String extern:   ""

    property Float value: 1.0;
    property Float norm_value: valuator.value;

    onExtern: {
        puts("on extern...")
        print "remote = "
        puts $remote
        print "extern = "
        puts valuator.extern
        meta = OSC::RemoteMetadata.new($remote, valuator.extern)
        puts meta
        valuator.label   = meta.short_name
        valuator.tooltip = meta.tooltip
        puts(meta.short_name)

        valuator.valueRef = OSC::RemoteParam.new($remote, valuator.extern)
        valuator.valueRef.callback = Proc.new {|x| valuator.setValue(x)}
        #valuator.valueRef.value    = 0.3
        puts("extern done...")

    }

    //Callback function which does not propagate info to remote API
    function setValue(v) {
        #puts "setValue..."
        if(valuator.root)
            valuator.value = v
            valuator.root.damage_item(valuator)
        end
    }

    function onMousePress(ev) {
        #puts "I got a mouse press (value)"
        valuator.prev = ev.pos
    }

    function onMouseMove(ev) {
        #puts "I got a mouse move (value)"
        if(ev.buttons.include? :leftButton)
            dy = ev.pos.y - valuator.prev.y
            updatePos(dy/200.0)
            valuator.prev = ev.pos
        end
    }

    function onMouseEnter(ev) {
        if(valuator.tooltip != "")
            valuator.root.log(:tooltip, valuator.tooltip)
        end
    }

    function updatePos(delta) {
        #puts "updatePos..."
        tmp = valuator.value - delta
        nvalue = limit(tmp, 0, 1)
        if(valuator.valueRef)
            valuator.valueRef.value = nvalue
            valuator.value = nvalue
            valuator.root.log(:user_value, valuator.valueRef.display_value, src=valuator.label)
        else
            valuator.value = nvalue
        end
        root.damage_item(valuator)
    }

    function onMerge(val)
    {
        valuator.value = val.value
    }

}
