Widget {
    id: text
    property Color textColor: Theme::TextColor
    property Float height: 0.5

    function class_name()
    {
        "Text"
    }

    function draw(vg)
    {
        scale = 100
        $vg.font_size scale
        bb = $vg.text_bounds(0, 0, label.upcase)


        vg.font_face("bold")
        if(w/(self.height*h) < bb)
            vg.font_size self.height*h
        else
            vg.font_size self.height*h
        end
        vg.text_align NVG::ALIGN_CENTER | NVG::ALIGN_MIDDLE
        vg.fill_color(self.textColor)
        vg.text(w/2,h/2,label.upcase)
    }

    function layout(l)
    {
        t = widget.class_name.to_sym
        scale = 100
        $vg.font_size scale
        bb = $vg.text_bounds(0, 0, label.upcase)
        selfBox = l.genBox t, text
        if(bb != 0 && !self.layoutOpts.include?(:ignoreAspect) &&
           !self.layoutOpts.include?(:no_constraint))
            #Width cannot be so small that letters overflow
            if(height == 0.5)
                l.sh([selfBox.w, selfBox.h], [-1.5, bb/scale], 0)
            else
                l.sh([selfBox.w, selfBox.h], [-1.0, bb/scale], 0)
            end
        end
        selfBox
    }
}
