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

    function onSpecial(k, mode)
    {
        return if @edit.nil?
        return if mode != :press
        if(k == :up)
            @edit.up
        elsif(k == :down)
            @edit.down
        elsif(k == :left)
            @edit.left
        elsif(k == :right)
            @edit.right
        end
        @state = true
        now = Time.new
        @next = now + 0.7
        damage_self
    }

    function onKey(k, mode)
    {
        return if mode != "press"
        pos = self.label.length
        pos = @edit.pos if @edit
        ll = self.label
        if(k.ord == 8)
            pos -= 1
            if(pos >= ll.length)
                self.label = ll.slice(0, ll.length-1)
            elsif(pos >= 0)
                self.label = ll.slice(0, pos) + ll.slice(pos+1, ll.length)
            end
        else
            self.label = ll.insert(pos, k)
        end
        ll = self.label
        self.valueRef.value = ll if self.valueRef
        @edit     = EditRegion.new($vg, ll, w-20, height*h)
        if(k.ord == 8)
            @edit.pos = pos
        else
            @edit.pos = pos+1
        end
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
        @edit     ||= EditRegion.new(vg, input, w-20, height*h)

        @edit.each_string do |x, y, str, cursor|
            if(cursor == false)
                vg.text(x+10, y, str)
            else
                if(@state)
                vg.text_align NVG::ALIGN_CENTER | NVG::ALIGN_MIDDLE
                    vg.text(x+10, y, str)
                end
            end
        end
    }
}
