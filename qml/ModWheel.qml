Widget {
    function draw(vg)
    {
        c1 = NVG.rgba(0x0b,0x0b,0x0b,255)
        c2 = NVG.rgba(0x52,0x52,0x52,255)
        bright_green = NVG.rgba(0x00,0xAe,0x9c, 255)
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
            v.rect(0, h/2-h/16, w, h/8)
            v.fill_color(bright_green)
            v.fill
        end
    }
}
