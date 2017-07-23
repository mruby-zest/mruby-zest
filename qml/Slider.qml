Valuator {
    id: slider

    property Float pad: 0.1
    property Bool  centered: true
    property Bool  visual:   false

    function class_name()
    {
        "Slider"
    }

    function draw_centered(vg)
    {
        pad2 = (1-2*pad)
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

    function draw_normal(vg)
    {
        col  = Theme::SliderActive
        col  = Theme::SliderVisActive if visual
        pad2 = (1-2*pad)
        src  = (h-h*pad2*value)
        dst  = h
        vg.path do |v|
            v.rect(pad*w, src, pad2*w, (src-dst).abs)
            v.fill_color col
            v.fill
        end
    }

    function draw(vg)
    {
        self.dragScale = h
        pad2 = (1-2*pad)
        vg.path do |v|
            v.rect(pad*w, pad*h, pad2*w, pad2*h)
            v.fill_color Theme::SliderBackground
            v.fill
        end

        vg.path do |v|
            v.move_to(pad* w, pad* h)
            v.line_to(pad* w, pad2*h)
            v.move_to(pad2*w, pad* h)
            v.line_to(pad2*w, pad2*h)
            v.stroke_color color(:black)
            v.stroke
        end

        return if value.class != Float

        draw_centered(vg) if  centered
        draw_normal(vg)   if !centered

        
        vg.path do |v|
            yloc = (h-h*pad2*value)
            v.move_to(w*pad,  yloc)
            v.line_to(w*pad2, yloc)
            v.stroke_color Theme::SliderStroke
            v.stroke_width 2.0
            v.stroke
        end
    }
    function onMousePress(ev) {
        mouse_handle(ev) if !visual
    }
}

