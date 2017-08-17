Widget {
    id: text
    property signal action: nil;
    property Color  textColor: Theme::TextColor
    property Float  height: 0.1
    property Object valueRef: nil

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

    onExtern: {
        text.valueRef = OSC::RemoteParam.new($remote, text.extern)
        text.valueRef.callback = Proc.new {|x|
            text.label = x;
            text.damage_self}
    }

    function class_name()
    {
        "Text"
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
        ll = self.label
        self.valueRef.value = ll if self.valueRef
        damage_self
    }

    function draw(vg)
    {
        background Theme::VisualBackground
        input  = self.label
        if(input.nil?)
            input  = "This is some random text which is hopefully "
            input += "is long enough to span a few different lines"
            input += ". I need it to in order to test multi-line "
            input += "rendering."
        end

        vg.font_face("bold")
        vg.font_size height*h
        vg.text_align NVG::ALIGN_LEFT | NVG::ALIGN_MIDDLE
        vg.fill_color(textColor)
        ypos = height*h/2
        lasty = ypos
        lastx = 0

        #Break into lines
        edit  = EditRegion.new(vg, input, w)
        lines = edit.lines
        line_widths = edit.line_widths

        n = lines.length
        (0...n).each do |i|
            str   = lines[i]
            width = line_widths[i]
            vg.text(0, ypos, str)
            lasty = ypos
            lastx = width
            ypos += height*h
        end

        if(@state)
            vg.text(lastx,lasty,"|")
        end
    }
}
