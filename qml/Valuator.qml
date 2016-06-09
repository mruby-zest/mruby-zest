Widget {
    id: valuator
    property Object valueRef: nil;
    property Object prev:     nil;

    property Float value: 1.0;

    property Function whenValue: nil;

    onExtern: {
        #puts("on extern...")
        #print "remote = "
        #puts $remote
        #print "extern = "
        #puts valuator.extern
        meta = OSC::RemoteMetadata.new($remote, valuator.extern)
        #puts meta
        valuator.label   = meta.short_name
        valuator.tooltip = meta.tooltip
        #puts(meta.short_name)

        valuator.valueRef = OSC::RemoteParam.new($remote, valuator.extern)
        valuator.valueRef.callback = Proc.new {|x| valuator.setValue(x)}
        #valuator.valueRef.value    = 0.3
        #puts("extern done...")

    }

    //Callback function which does not propagate info to remote API
    function setValue(v) {
        #puts "setValue..."
        if(valuator.root)
            valuator.value = v
            valuator.root.damage_item(valuator)
        end
    }

    function create_radial()
    {
        puts "creating the radial menu..."
        gbl_cx = valuator.global_x + 0.5*valuator.w
        gbl_cy = valuator.global_y + 0.5*valuator.h
        gbl_w  = window.w
        gbl_h  = window.h

        ropt = [gbl_cx, gbl_cy, gbl_w-gbl_cx, gbl_h-gbl_cy].min
        #print "maximum radius is "
        #puts ropt
        #puts [gbl_cx, gbl_cy, gbl_w, gbl_h]
        #puts [gbl_cx, gbl_cy, gbl_w-gbl_cx, gbl_h-gbl_cy]

        diameter = [2.0*ropt, 3.0*0.5*(valuator.w+valuator.h)].min

        widget = RadialMenu.new(valuator.db)
        widget.w = diameter
        widget.h = diameter
        widget.x = valuator.w/2-diameter/2
        widget.y = valuator.h/2-diameter/2
        widget.layer = 2
        widget.callback = lambda {|sel|
            case sel
            when 0
                valueRef.midi_learn if valueRef
            when 1
                valueRef.rand if valueRef
            when 2
                valueRef.midi_unlearn if valueRef
            when 3
                valueRef.default if valueRef
            end
        }
        print "widget.x = "
        puts widget.x

        Qml::add_child(valuator, widget)
        valuator.root.smash_draw_seq
        valuator.root.damage_item widget
    }

    function onMousePress(ev) {
        #puts "I got a mouse press (value)"
        if(ev.buttons.include? :leftButton)
            valuator.prev = ev.pos
        elsif(ev.buttons.include? :rightButton)
            if(children.empty?)
                create_radial
            end
        else
            valuator.prev = nil
        end
    }

    function onMouseMove(ev) {
        #puts "I got a mouse move (value)"
        if(valuator.prev)
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
            old_dsp = valuator.valueRef.display_value
            valuator.valueRef.value = nvalue
            valuator.value = nvalue
            new_dsp = valuator.valueRef.display_value
            whenValue.call if whenValue && old_dsp != new_dsp
            valuator.root.log(:user_value, valuator.valueRef.display_value, src=valuator.label)
        else
            valuator.value = nvalue
        end
        root.damage_item(valuator)
    }

    function onMerge(val)
    {
        valuator.value = val.value if(val.respond_to?(:value))
    }

}
