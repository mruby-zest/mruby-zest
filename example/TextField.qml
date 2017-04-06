Widget {
    property Symbol style: :normal
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
        if(self.style == :overlay)
            draw_overlay(vg)
        else
            draw_normal(vg)
        end

    }

    function draw_overlay(vg)
    {
        background color("1b1c1c")
        vg.font_face("bold")
        vg.font_size h*0.8
        vg.text_align NVG::ALIGN_LEFT | NVG::ALIGN_MIDDLE
        vg.fill_color = color("56c0a5")
        l = "..."
        if(label.class == String && !label.empty?)
            l = label.clone
        elsif(label.class == Array)
            l = label[0].clone
        end

        (0...l.length).each do |i|
            l[i] = "?" if l.getbyte(i) > 127
        end

        bnd = vg.text_bounds(0,0,l+"|")
        if(bnd+8 > self.w)
            vg.font_size self.h*self.w/(bnd+8)*0.8
            bnd = vg.text_bounds(0,0,l)
        end

        vg.text(8,h/2,l)
        if(@state)
            vg.text(8+bnd,h/2,"|")
        end
    }
    function draw_normal(vg)
    {
        background Theme::GeneralBackground
        vg.font_face("bold")
        vg.font_size h*0.8
        vg.text_align NVG::ALIGN_LEFT | NVG::ALIGN_MIDDLE
        vg.fill_color = Theme::TextColor
        l = label.empty? ? "..." : label.clone

        (0...l.length).each do |i|
            l[i] = "?" if l.getbyte(i) > 127
        end

        vg.text(8,h/2,l)
        bnd = vg.text_bounds(0,0,l)
        if(@state)
            vg.text(8+bnd,h/2,"|")
        end
    }

    function onMerge(val)
    {
        self.label = val.label
    }
}
