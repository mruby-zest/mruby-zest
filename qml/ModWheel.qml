Valuator {
    function draw(vg)
    {
        c1 = color("0b0b0b")
        c2 = color("525252")
        bright_green = color("00AE9C")
        grad1 = vg.linear_gradient(0,0,0,h/2,c1,c2)
        grad2 = vg.linear_gradient(0,h/2,0,h,c2,c1)
        vg.path do |v|
            v.rect(0, 0, w, h/2)
            vg.fill_paint(grad1)
            v.fill
        end
        vg.path do |v|
            v.rect(0, h/2, w, h/2)
            vg.fill_paint(grad2)
            v.fill
        end
        vg.path do |v|
            v.rect(0, h*7/8*(1-value), w, h/8)
            scale = 2*(0.5-[0.5-value, value-0.5].max)
            scale = scale+0.4
            bright_green = NVG.rgba(0x00*scale,0xAe*scale,0x9c*scale, 255)
            v.fill_color(bright_green)
            v.fill
        end
    }
}
