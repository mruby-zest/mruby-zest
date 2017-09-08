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
    
    function animate()
    {
        if(root.key_widget != self)
            @next = nil
            if(@state)
                @state = nil
                damage_self
            end
            return
        end
        now = Time.new
        if(@next.nil?)
            @next = now + 0.1
            return
        elsif(@next < now)
            @state = !@state
            @next = now + 0.7
            damage_self
        end
    }
    
    function draw_text(vg)
    {
        text_color1   = Theme::TextActiveColor
        text_color2   = Theme::TextColor
        vg.font_face("bold")
        vg.font_size h*self.textScale
        if(value == true)
            vg.fill_color(text_color1)
        else
            vg.fill_color(text_color2)
        end
        vg.text_align NVG::ALIGN_LEFT | NVG::ALIGN_MIDDLE
        if(@state)
            vg.text(8,h/2,button.label.upcase + "|")
        else
            vg.text(8,h/2,button.label.upcase)
        end
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

    function onKey(k, mode)
    {
        return if mode != "press"
        if(k.ord == 8)
            self.label[-1] = "\0" if self.label.length > 0
            self.label = self.label[0...-1]
        else
            self.label += k
        end
        whenValue.call if whenValue
        valueRef.value = self.label if valueRef
        damage_self
    }
}
