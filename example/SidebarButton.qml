Widget {
    id: button
    property Bool value: false;
    function draw(vg)
    {
        h = button.h
        w = button.w
        #puts("drawing a button...")
        bright_green = NVG.rgba(0x00,0xAe,0x9c, 255)
        dark_green   = NVG.rgba(0x00,0x73,0x68,0xff)
        grad = vg.linear_gradient(0,0,0,h, bright_green, dark_green)
        vg.stroke_color(NVG.rgba(0,0,0,0x80))

        grey1 = NVG.rgba(0x4a,0x4a,0x4a, 255)
        grey2 = NVG.rgba(0x37,0x37,0x37,0xff)
        grad2 = vg.linear_gradient(0,0,0,h, grey1, grey2)
        vg.path do |v|
            v.rect(0,0,w,h)
            if(value)
                v.fill_paint(grad)
            else
                v.fill_paint(grad2)
            end
            v.stroke_width 1
            v.fill
            v.stroke
        end

        textcolor1 = NVG.rgba(0x7a, 0xff, 0xf7, 0xff)
        textcolor2 = bright_green
        vg.font_face("bold")
        vg.font_size h*0.55
        vg.text_align NVG::ALIGN_CENTER | NVG::ALIGN_MIDDLE
        if(value)
            vg.fill_color(textcolor1)
        else
            vg.fill_color(textcolor2)
        end
        vg.text(w/2,h/2,label.upcase)
        
    }

}
