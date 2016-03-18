Widget {
    id: text
    property signal action: nil;
    property Color textColor: NVG.rgba(0x3a,0xc5,0xec,255);

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
        #    v.fill_color(NVG.rgba(128, 128, 128, 255))
        #    v.fill
        #end
        vg.font_face("bold")
        vg.font_size h/2
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
        if(bb != 0)
            #Width cannot be so small that letters overflow
            l.sh([selfBox.w, selfBox.h], [-1.5, bb/scale], 0)
        end
        selfBox
    }
}
