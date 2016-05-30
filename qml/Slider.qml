Valuator {
    id: slider

    function class_name()
    {
        "Slider"
    }

    //function layout(l)
    //{
    //    t = widget.class_name.to_sym
    //    selfBox = l.genBox t, widget
    //    l.aspect(selfBox, 4, 1)
    //    selfBox
    //}

    function draw(vg)
    {
        pad  = 0.1
        pad2 = (1-2*pad)
        vg.path do |v|
            v.rect(pad*w, pad*h, pad2*w, pad2*h)
            v.fill_color color("0f0000")
            v.fill
        end
        if(value > 0.5)
            src = (h/2-h*pad2*(value-0.5))
            dst = h/2
            vg.path do |v|
                v.rect(pad*w, src, pad2*w, (src-dst).abs)
                v.fill_color Theme::SliderActive
                v.fill
            end
        else
            vg.path do |v|
                v.rect(pad*w, h/2, pad2*w, pad2*h*(0.5-value))
                v.fill_color Theme::SliderActive
                v.fill
            end
        end
    }
}

