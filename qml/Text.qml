Widget {
    id: text
    property Color textColor: Theme::TextColor
    property Float height: 0.5
    property Symbol align: :center
    property Symbol letterCase: :normal

    function class_name()
    {
        "Text"
    }

    function draw(vg)
    {
        scale = 100
        $vg.font_size scale

        labelDisplay = ""

        case self.letterCase
        when :normal
            labelDisplay = label
        when :upper
            labelDisplay = label.upcase
        when :lower
            labelDisplay = label.downcase
        else
            puts "[ERROR]: Invalid letterCase property detected in a Text widget: #{self.letterCase}"
        end

        bb = $vg.text_bounds(0, 0, labelDisplay)

        vg.font_face("bold")
        if(w/(self.height*h) < bb)
            vg.font_size self.height*h
        else
            vg.font_size self.height*h
        end
        vg.fill_color(self.textColor)
        if(align == :center)
            vg.text_align NVG::ALIGN_CENTER | NVG::ALIGN_MIDDLE
            vg.text(w/2,h/2,labelDisplay)
        else
            vg.text_align NVG::ALIGN_LEFT | NVG::ALIGN_MIDDLE
            vg.text(0,h/2,labelDisplay)
        end
    }

    function layout(l, selfBox)
    {
        scale = 100
        $vg.font_size scale
        bb = $vg.text_bounds(0, 0, label.upcase)
        if(bb != 0 && !self.layoutOpts.include?(:ignoreAspect) &&
           !self.layoutOpts.include?(:no_constraint))
            #Width cannot be so small that letters overflow
            if(height == 0.5)
                l.aspect(selfBox, bb, 1.5*scale)
            else
                l.aspect(selfBox, bb, scale)
            end
        end
        selfBox
    }
}
