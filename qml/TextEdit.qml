Widget {
    id: text
    property signal action: nil;
    property Color  textColor: Theme::TextColor
    property Float  height: 0.1
    property Object valueRef: nil


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
            self.label[-1] = "\0"
            self.label = self.label[0...-1]
        else
            self.label += k
        end
        ll = self.label
        puts ll
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
        vg.text_box(0,height*h,w, input)
    }
}
