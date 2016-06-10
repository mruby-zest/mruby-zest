Widget {
    id: text
    property signal action: nil;
    property Color textColor: Theme::TextColor
    property Float height: 0.5

    function class_name()
    {
        "Text"
    }

    function draw(vg)
    {
        w=text.w
        h=text.h
        #vg.path do |v|
        #    v.rect(w/32, h/4, w*30/32, h/2)
        #    v.fill_color color("802080")
        #    v.fill
        #end

        scale = 100
        $vg.font_size scale
        bb = $vg.text_bounds(0, 0, label.upcase)

        #puts bb/100
        #puts "#{w.to_i}/#{h.to_i} = #{w/h}"
        #puts "  #{bb*h/100}"

        vg.font_face("bold")
        if(w/(text.height*h) < bb)
            vg.font_size text.height*h
        else
            vg.font_size text.height*h
        end
        vg.text_align NVG::ALIGN_CENTER | NVG::ALIGN_MIDDLE
        vg.fill_color(textColor)
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
