Button {
    property Color bg: nil
    function draw(vg)
    {
        on_color      = Theme::ButtonActive
        text_color1   = color("52FAFE")
        text_color2   = color("B9CADE")
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
        vg.text(8,h/2,button.label.upcase)
    }
}
