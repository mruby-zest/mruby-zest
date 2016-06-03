Widget {
    id: button
    property Function whenClick: nil
    property Bool value: false

    function onMousePress(ev) {
        self.value = !self.value
        if(root)
            root.damage_item self
        end
        self.whenClick.call if whenClick
    }

    function draw(vg)
    {
        h = button.h
        w = button.w
        #puts("drawing a button...")
        bright_green = NVG.rgba(0x00,0xAe,0x9c, 255)
        dark_green   = NVG.rgba(0x00,0x73,0x68,0xff)
        grad = vg.linear_gradient(0,0,0,h, bright_green, dark_green)
        vg.stroke_color(NVG.rgba(0,0,0,0x80))

        off_color     = color("505E6C")
        grey1 = NVG.rgba(0x4a,0x4a,0x4a, 255)
        grey2 = NVG.rgba(0x37,0x37,0x37,0xff)
        grad2 = vg.linear_gradient(0,0,0,h, grey1, grey2)
        vg.path do |v|
            v.rect(0,0,w,h)
            if(value)
                bright_green = NVG.rgba(0x00,0xAe,0x9c, 255)
                dark_green   = NVG.rgba(0x00,0x73,0x68,0xff)
                grad = vg.linear_gradient(0,0,0,h, bright_green, dark_green)
                v.fill_paint grad
            else
                v.fill_color off_color
            end
            v.stroke_width 1
            v.fill
            v.stroke
        end

        text_color1   = color("52FAFE")
        text_color2   = color("B9CADE")
        vg.font_face("bold")
        vg.font_size h*0.55
        vg.text_align NVG::ALIGN_CENTER | NVG::ALIGN_MIDDLE
        if(value)
            vg.fill_color(text_color1)
        else
            vg.fill_color(text_color2)
        end
        vg.text(w/2,h/2,label.upcase)
        
    }

}
