ToggleButton {
    function draw_text(vg)
    {
        text_color1   = Theme::TextActiveColor
        text_color2   = Theme::TextColor
        vg.font_face("bold")
        vg.font_size h*self.textScale/2
        if(value == true)
            vg.fill_color(text_color1)
        else
            vg.fill_color(text_color2)
        end
        if(layoutOpts.include? :left_text)
            vg.text_align NVG::ALIGN_LEFT | NVG::ALIGN_MIDDLE
            vg.text(8,h/2,button.label.upcase)
        else
            vg.text_align NVG::ALIGN_CENTER | NVG::ALIGN_MIDDLE
            vg.text(w/2,h*0.666,"GL FILTER")
            vg.text(w/2,h*0.333,"BYPASS")
        end
    }

    function layout(l, selfBox)
    {
        if(!self.layoutOpts.include?(:no_constraint))
            if(label.length == 1)
                l.aspect(selfBox, 1, 1)
            else
                scale = 100
                $vg.font_size scale
                bb1 = $vg.text_bounds(0, 0, "BYPASS")
                bb2 = $vg.text_bounds(0, 0, "GL FILTER")
                bb  = [bb1, bb2].max/2
                if(bb != 0)
                    #Width cannot be so small that letters overflow
                    self.aspect2(selfBox, bb, scale)
                end
            end
        end
        selfBox
    }
}
