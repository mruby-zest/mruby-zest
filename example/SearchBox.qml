Widget {
    property Function whenValue: nil

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

    function draw(vg)
    {
        background Theme::GeneralBackground
        vg.font_face("bold")
        vg.font_size h*0.8
        vg.text_align NVG::ALIGN_LEFT | NVG::ALIGN_MIDDLE
        vg.fill_color = Theme::TextColor
        l = label
        if(root.key_widget != self and label.empty?)
            vg.fill_color = Theme::BackgroundTextColor
            l = "search..."
        end
        vg.text(8,h/2,l.upcase)
        bnd = vg.text_bounds(0,0,l.upcase)
        if(@state)
            vg.text(8+bnd,h/2,"|")
        end
    }

    function onKey(k, mode)
    {
        return if mode != "press"
        if(k.ord == 8)
            self.label = self.label[0...-1]
        else
            self.label += k
        end
        whenValue.call if whenValue
        damage_self
    }

    function onMerge(val)
    {
        self.label = val.label
    }
}
