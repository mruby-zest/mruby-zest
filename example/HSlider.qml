Valuator {
    property Bool centered: false;
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
            src = (w/2-w*pad2*(value-0.5))
            dst = w/2
            vg.path do |v|
                v.rect(src, pad*h, (src-dst).abs, pad2*h)
                v.fill_color Theme::SliderActive
                v.fill
            end
        else
            vg.path do |v|
                v.rect(w/2, pad*h, pad2*w*(0.5-value), pad2*h)
                v.fill_color Theme::SliderActive
                v.fill
            end
        end
    }
}
