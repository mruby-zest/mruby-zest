Widget {
    id: valuator
    property Object valueRef: nil;
    property Object prev:     nil;

    property Float value: 1.0;

    property Float dragScale: 200.0;
    property Bool  vertical: true

    property Function whenValue: nil;

    onExtern: {
        meta = OSC::RemoteMetadata.new($remote, valuator.extern)
        valuator.label   = meta.short_name
        valuator.tooltip = meta.tooltip

        valuator.valueRef = OSC::RemoteParam.new($remote, valuator.extern)
        valuator.valueRef.callback = Proc.new {|x| valuator.setValue(x)}

    }

    //Callback function which does not propagate info to remote API
    function setValue(v) {
        self.value = lim(v, 0.0, 1.0)
        damage_self
    }

    function create_radial()
    {
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

    function onScroll(ev)
    {
        updatePos(ev.dy/50.0)
    }

    function onMousePress(ev) {
        $remote.midi_learn extern if(root.learn_mode && extern)
        #puts "I got a mouse press (value)"
        if(ev.buttons.include? :leftButton)
            valuator.prev = ev.pos
        elsif(ev.buttons.include? :rightButton)
            if(children.empty?)
                create_radial
            end
        elsif(ev.buttons.include? :middleButton)
            #Reset
            reset_value = 64/127.0
            if(valueRef)
                old_dsp = self.valueRef.display_value

                self.valueRef.value = reset_value
                self.value = reset_value
                new_dsp = self.valueRef.display_value
                whenValue.call if whenValue && old_dsp != new_dsp
                valuator.root.log(:user_value, valuator.valueRef.display_value, src=valuator.label)
            else
                self.value = reset_value
            end
            damage_self
        else
            valuator.prev = nil
        end
    }

    function onMouseMove(ev) {
        #puts "I got a mouse move (value)"
        if(prev)
            delta = if(vertical)
                +(ev.pos.y - self.prev.y)
            else
                -(ev.pos.x - self.prev.x)
            end
            updatePos(delta/dragScale)
            self.prev = ev.pos
        end
    }

    function onMouseEnter(ev) {
        if(self.tooltip != "")
            self.root.log(:tooltip, self.tooltip)
        end
    }

    function lim(x, low, high)
    {
        [low, [x, high].min].max
    }

    function updatePos(delta) {
        tmp = valuator.value - delta
        nvalue = lim(tmp, 0.0, 1.0)
        if(valuator.valueRef)
            old_dsp = valuator.valueRef.display_value
            valuator.valueRef.value = nvalue
            valuator.value = nvalue
            new_dsp = valuator.valueRef.display_value
            whenValue.call if whenValue && old_dsp != new_dsp
            valuator.root.log(:user_value, valuator.valueRef.display_value, src=valuator.label)
        else
            valuator.value = nvalue
            whenValue.call if whenValue
        end
        damage_self
    }

    function onMerge(val)
    {
        valuator.value = val.value if(val.respond_to?(:value))
    }

}
