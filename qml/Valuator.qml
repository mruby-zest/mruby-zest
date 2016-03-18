Widget {
    id: valuator
    property Object valueRef: nil;
    property Object  prev: nil;

    property Float value: 1.0;
    property Float norm_value: valuator.value;

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

    function updatePos(delta) {
        tmp = valuator.value - delta
        nvalue = limit(tmp, 0, 1)
        if(valueRef)
            valuator.valueRef.update(nvalue)
        else
            valuator.value = nvalue
        end
    }

    function onMerge(val)
    {
        valuator.value = val.value
    }

}
