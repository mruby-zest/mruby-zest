Widget {
    id: fancy
    property Function whenClick: nil
    property Bool     value:     false
    property Object   valueRef:  nil
    function class_name() { "FancyButton" }

    onExtern: {
        meta = OSC::RemoteMetadata.new($remote, fancy.extern)
        fancy.tooltip = meta.tooltip

        fancy.valueRef = OSC::RemoteParam.new($remote, fancy.extern)
        fancy.valueRef.callback = Proc.new {|x| fancy.set_sub_value(x)}
        pow.extern = fancy.extern
        pow.extern()
    }

    function set_value(x)
    {
        self.value = x
        damage_self
    }

    function set_sub_value(x)
    {
        pow.value = x
        damage_self
    }

    function onMouseEnter(ev) {
        if(self.tooltip != "")
            self.root.log(:tooltip, self.tooltip)
        end
    }

    function draw(vg)
    {
        pad = 0
        off_color     = Theme::ButtonInactive
        on_color      = Theme::ButtonActive
        cs = 0
        vg.path do |v|
            v.rounded_rect(w*pad, h*pad, w*(1-2*pad), h*(1-2*pad), 3)
            if(self.value == true)
                cs = 1
                v.fill_color on_color
            elsif(self.value.class == Float && self.value != 0)
                cs = 2
                t = self.value
                on = on_color
                of = Theme::ButtonGrad1
                v.fill_color(color_rgb(on.r*t + of.r*(1-t),
                                       on.g*t + of.g*(1-t),
                                       on.b*t + of.b*(1-t)))
            else
                paint = v.linear_gradient(0,0,0,h,
                Theme::ButtonGrad1, Theme::ButtonGrad2)
                v.fill_paint paint
            end
            v.fill
            v.stroke_width 1
            v.stroke

        end

        vg.path do |v|
            hh = h/20
            v.move_to(w*pad+3,       h*pad+hh)
            v.line_to(w*(1-2*pad)-2, h*pad+hh)
            if(cs == 0)
                v.stroke_color color("5c5c5c")
            elsif(cs == 1)
                v.stroke_color color("16a39c")
            end
            if([0,1].include?(cs))
                v.stroke_width hh
                v.stroke
            end
        end


        text_color1   = Theme::TextActiveColor
        text_color2   = Theme::TextColor
        vg.font_face("bold")
        vg.font_size h*0.6
        vg.text_align NVG::ALIGN_CENTER | NVG::ALIGN_MIDDLE

        if(value)
            vg.fill_color(text_color1)
        else
            vg.fill_color(text_color2)
        end

        vg.text(w/2 + pow.w / 2,h/2,label.upcase)
    }

    function onMousePress(ev) {
        #self.value = !self.value
        #damage_self
        valueRef.value = true if(value == false && valueRef)
        whenClick.call if whenClick
    }

    function layout(l,selfBox)
    {
        box = pow.fixed(l, selfBox, 0, 0, 0.25, 1)
        box.x = 0
        box.y = 0
        box.h = selfBox.h
        if(layoutOpts.include? :no_constraint)
            box.w = 0.25*selfBox.w
        end
        selfBox
    }

    PowButton {
        id: pow
        function class_name() { "PowButton" }
    }

}
