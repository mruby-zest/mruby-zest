Valuator {
    property Bool centered: false;
    property Float pad: 0.02
    property Float height: 0.6
    vertical: false

    function draw_centered(vg, pad)
    {
        pad2 = (1-2*pad)
        if(value >= 0.5)
            vv   = [0.01, value-0.5+0.01].max
            src = (w*0.5-w*pad2*vv)
            dst = (w*0.51)
            vg.path do |v|
                v.rect(src, pad*h, (src-dst).abs, pad2*h)
                v.fill_color Theme::SliderActive
                v.fill
            end
        else
            vv   = [0.01, 0.5-value+0.01].max
            vg.path do |v|
                v.rect(w*0.49, pad*h, pad2*w*vv, pad2*h)
                v.fill_color Theme::SliderActive
                v.fill
            end
        end
    }


    function draw(vg)
    {
        self.dragScale = w
        pad2 = (1-2*pad)
        vg.path do |v|
            v.rect(pad*w, pad*h, pad2*w, pad2*h)
            v.fill_color Theme::SliderBackground
            v.stroke_color color(:black)
            v.fill
            v.stroke
        end

        if(centered)
            draw_centered(vg, pad)
        else
            vg.path do |v|
                v.rect(pad*w, pad*h, (1-value)*w*pad2, pad2*h)
                v.fill_color Theme::SliderActive
                v.fill
            end
        end

        vg.font_face("bold")
        vg.font_size height*h
        vg.text_align NVG::ALIGN_CENTER | NVG::ALIGN_MIDDLE
        vg.fill_color(Draw::fade(Theme::TextColor))
        vg.text(w/2,h/2,label.upcase)

    }
}
