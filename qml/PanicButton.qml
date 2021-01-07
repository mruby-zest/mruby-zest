TriggerButton {
    whenValue: lambda { $remote.action("/Panic") }
    function layout(l, selfBox) {
        selfBox
    }

    function draw(vg)
    {
        text_color1   = color("505050")
        text_color2   = color("B9CADE")
        pad = 1.0/64
        vg.path do |v|
            v.rect(w*pad, h*pad, w*(1-2*pad), h*(1-2*pad))
            paint = v.linear_gradient(0,0,0,h,
            Theme::ButtonGrad1, Theme::ButtonGrad2)
            v.fill_paint paint
            v.fill
            v.stroke_width 1
            v.stroke
        end
        vg.path do |v|
            angle = 30*3.14/180
            delta = 0.4*[w,h].min
            dy = delta*Math.sin(angle)
            dx = delta*Math.cos(angle)
            cy = 0.6*h
            v.move_to(0.5*w,    cy-delta)
            v.line_to(0.5*w+dx, cy+dy)
            v.line_to(0.5*w-dx, cy+dy)
            v.close_path
            v.fill_color(text_color2)
            v.fill
        end

        vg.font_face("bold")
        vg.font_size h*0.75
        vg.text_align NVG::ALIGN_CENTER | NVG::ALIGN_MIDDLE
        vg.fill_color(text_color1)
        vg.text(w/2,h/2,"!")

    }

}
