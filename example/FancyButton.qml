Widget {
    id: fancy
    property Bool value: false;
    function class_name() { "FancyButton" }
    function draw(vg)
    {
        #puts("drawing a fancy button <#{fancy.ui_path}>...")
        bright_green = NVG.rgba(0x00,0xAe,0x9c, 255)
        dark_green   = NVG.rgba(0x00,0x73,0x68,0xff)
        grad = vg.linear_gradient(0,0,0,h, bright_green, dark_green)
        vg.stroke_color(NVG.rgba(0,0,0,0xa0))
        vg.path do |v|
            v.rect(0,0,w/4,h)
            v.fill_paint(grad)
            v.fill
            v.stroke_width 3
            v.stroke
        end

        grey1 = NVG.rgba(0x4a,0x4a,0x4a, 255)
        grey2 = NVG.rgba(0x37,0x37,0x37,0xff)
        grad2 = vg.linear_gradient(0,0,0,h, grey1, grey2)
        vg.path do |v|
            pad = 0
            v.rect(w/4+pad,0,w*3/4,h)
            if(value)
                v.fill_paint(grad)
            else
                v.fill_paint(grad2)
            end
            v.fill
            v.stroke
        end

        textcolor1 = NVG.rgba(0x7a, 0xff, 0xf7, 0xff)
        textcolor2 = bright_green
        vg.font_face("bold")
        vg.font_size h*0.6
        vg.text_align NVG::ALIGN_CENTER | NVG::ALIGN_MIDDLE
        if(value)
            vg.fill_color(textcolor1)
        else
            vg.fill_color(textcolor2)
        end
        vg.text(w*1.25/2,h/2,label.upcase)
        
    }

    function layout(l)
    {
        selfBox = l.genBox :fancyButton, self
        chldBox = l.genBox :fancyButtonPow, pow
        l.fixed(chldBox, selfBox, 0, 0, 0.25, 1)
        selfBox
    }

    PowButton {
        id: pow
        function class_name() { "PowButton" }
    }

}
