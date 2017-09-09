Button {
    property Color bg_color: color("000000")
    function draw_button(vg) {
        cs = 0
        vg.path do |v|
            v.rounded_rect(w*pad, h*pad, w*(1-2*pad), h*(1-2*pad), 2)
            v.fill_color(self.bg_color)
            v.fill
            v.stroke_width 1
            v.stroke
        end
    }
    
    function draw_text(vg)
    {
        text_color1   = color("111111")
        text_color2   = color("eeeeee")
        vg.font_face("bold")
        vg.font_size h*self.textScale
        if((self.bg_color.r + self.bg_color.b + self.bg_color.g) > 0.9)
            vg.fill_color(text_color1)
        else
            vg.fill_color(text_color2)
        end

        if(layoutOpts.include? :left_text)
            vg.text_align NVG::ALIGN_LEFT | NVG::ALIGN_MIDDLE
            vg.text(8,h/2,self.label)
        else
            vg.text_align NVG::ALIGN_CENTER | NVG::ALIGN_MIDDLE
            vg.text(w/2,h/2,self.label)
        end
    }
}
