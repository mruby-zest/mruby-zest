Button {
    id: app
    BusyLoop {
        id: lp
    }
    function onMousePress(ev) {
        if(ev.buttons.include? :leftButton)
            self.state = :applying
            self.value = 1.0
            whenValue.call if whenValue
            lp.spin = true
            damage_self
        elsif(ev.buttons.include? :rightButton)
            if(children.length == 1)
                create_radial
            end
        end
    }

    property Symbol state:    :off
    property Object valueRef: nil
    onExtern: {
        app.valueRef = OSC::RemoteParam.new($remote, app.extern)
        app.valueRef.callback = lambda {|x|
            app.setValue(x);
            if(!x)
                app.state = :off
            else
                app.state = :waiting
            end}
    }

    function create_radial()
    {
        gbl_cx = self.global_x + 0.5*self.w
        gbl_cy = self.global_y + 0.5*self.h
        gbl_w  = window.w
        gbl_h  = window.h

        ropt = [gbl_cx, gbl_cy, gbl_w-gbl_cx, gbl_h-gbl_cy].min

        diameter = [2.0*ropt, 3.0*0.5*(self.w+self.h)].min

        widget = RadialMenu.new(self.db)
        widget.w = diameter
        widget.h = diameter
        widget.x = self.w/2-diameter/2
        widget.y = self.h/2-diameter/2
        widget.layer = 2
        widget.fields = ["off", "1 sec", "off", "10 sec"]
        widget.callback = lambda {|sel|
            case sel
            when 0
                $auto_apply_dt = 1.0/0.0
            when 1
                $auto_apply_dt = 1.0
            when 2
                $auto_apply_dt = 1.0/0.0
            when 3
                $auto_apply_dt = 10.0
            end
            puts "auto apply dt is:"
            puts $auto_apply_dt
            puts sel
        }

        Qml::add_child(self, widget)
        self.root.smash_draw_seq
        self.root.damage_item widget
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
        now = Time.new
        $auto_apply_dt   ||= 1.0/0.0
        @auto_apply_last ||= now
        if(self.state == :waiting && (now-@auto_apply_last) > $auto_apply_dt)
            self.state = :applying
            self.value = 1.0
            whenValue.call if whenValue
            lp.spin = true
            damage_self
            @auto_apply_last = now
        end

        if(self.state == :waiting)
            @phase ||= 0.0
            self.value = Math.sin(3.14*@phase)
            @phase += 0.01
            @phase -= 1.0 if @phase > 1.0
            damage_self
            return
        end

        return if self.value == 0
        return if self.value == false
        return if self.value == true
        self.value *= 0.7
        self.value  = 0 if self.value < 0.02
        damage_self
    }


    function layout(l, selfBox) {
        scale = 100
        $vg.font_size scale
        bb = $vg.text_bounds(0, 0, "000 " + label.upcase)
        if(bb != 0)
            #Width cannot be so small that letters overflow
            l.aspect(selfBox, bb, scale)
        end

        lp.fixed(l, selfBox, 0.1, 0.1, 0.2, 0.8)
        selfBox
    }
}
