Widget {
    id: textedit
    property Function whenValue: nil
    property Object   valueRef:  nil
    property Bool     upcase:    true
    property String   ext:       nil
    onExtern: {
        ref = OSC::RemoteParam.new($remote, textedit.extern)
        ref.callback = lambda {|x|
            textedit.label = x;
            textedit.damage_self
        }
        textedit.valueRef = ref
    }
    function draw(vg)
    {
        background Theme::GeneralBackground
        vg.font_face("bold")
        vg.font_size h*0.8
        vg.text_align NVG::ALIGN_LEFT | NVG::ALIGN_MIDDLE
        vg.fill_color = Theme::TextColor
        l = label.empty? ? "..." : label.clone
        l = l+self.ext if self.ext && !l.end_with?(self.ext)
        l = l.upcase if self.upcase
        (0...l.length).each do |i|
            l[i] = "?" if l.getbyte(i) > 127
        end
        vg.text(8,h/2,l)
    }

    function onKey(k, mode)
    {
        return if mode != "press"
        if(k.ord == 8)
            self.label = self.label[0...-1]
        elsif k.ord >= 32
            self.label += k
        end
        whenValue.call if whenValue
        valueRef.value = self.label if valueRef
        damage_self
    }

    function onMerge(val)
    {
        self.label = val.label
    }
}
