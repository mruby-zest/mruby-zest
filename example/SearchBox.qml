Widget {
    property Function whenValue: nil
    function draw(vg)
    {
        background Theme::GeneralBackground
        vg.font_face("bold")
        vg.font_size h*0.8
        vg.text_align NVG::ALIGN_LEFT | NVG::ALIGN_MIDDLE
        vg.fill_color = Theme::TextColor
        l = label.empty? ? "search..." : label
        vg.text(8,h/2,l.upcase)
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
