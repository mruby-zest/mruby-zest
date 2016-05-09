Widget {
    id: valuator
    property Object valueRef: nil;
    property Object prev:     nil;

    property String extern:   ""

    property Float value: 1.0;
    property Float norm_value: valuator.value;

    onExtern: {
        puts("on extern...")
        meta = OSC::RemoteMetadata.new($remote, valuator.extern)
        valuator.label = meta.short_name
        puts(meta.short_name)
        puts("extern done...")

    }

    onValueRef: {
        puts("entering onValueRef")
        if(valuator.valueRef)
            registerExternal(valuator.valueRef)
            bind(valuator, "value", "valuator.valueRef.value")
        end
    }

    function setValue(v) {
        if(valueRef)
            valuator.valueRef.setValue(v)
        else
            value = v
        end

        puts "setValue..."
        root.damage(Rect.new(abs_x, abs_y, valuator.w, valuator.h), 0)
    }

    function onMousePress(ev) {
        puts "I got a mouse press (value)"
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

    function updatePos(delta) {
        tmp = valuator.value - delta
        nvalue = limit(tmp, 0, 1)
        if(valueRef)
            valuator.valueRef.update(nvalue)
        else
            valuator.value = nvalue
        end
        root.draw_damage(Rect.new(abs_x, abs_y, valuator.w, valuator.h), 0)
        #root.draw_damage(Rect.new(0,0,512,512), 0)
    }

    function onMerge(val)
    {
        valuator.value = val.value
    }

}
