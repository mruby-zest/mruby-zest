Button {
    property Color bg: nil
    property Bool  doupcase: true
    function draw(vg)
    {
        on_color      = Theme::ButtonActive
        vg.path do |v|
            v.rect(w*pad, h*pad, w*(1-2*pad), h*(1-2*pad))
            if(button.value)
                v.fill_color on_color
            else
                v.fill_color bg if bg
            end
            v.fill
        end

        vg.font_face("bold")
        vg.font_size h*self.textScale
        vg.text_align NVG::ALIGN_LEFT | NVG::ALIGN_MIDDLE
        vg.fill_color = if(value)
            Theme::TextActiveColor
        else
            Theme::TextColor
        end
        ll = self.label.clone
        ll = ll.upcase if self.doupcase
        (0...ll.length).each do |i|
            ll[i] = "?" if ll.getbyte(i) > 127
        end
        vg.text(8,h/2,ll)
    }
    function onMouseEnter(ev) {
        if(self.tooltip != "")
            self.root.log(:tooltip, self.tooltip)
        end
    }
}
