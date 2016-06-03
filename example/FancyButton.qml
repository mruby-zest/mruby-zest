Widget {
    id: fancy
    property Function whenClick: nil
    property Bool     value:     false
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
            v.stroke_width 1
            v.stroke
        end

        off_color     = color("505E6C")
        grey1 = color("4a4a4a")
        grey2 = color("373737")
        grad2 = vg.linear_gradient(0,0,0,h, grey1, grey2)
        vg.path do |v|
            pad = 0
            v.rect(w/4+pad,0,w*3/4,h)
            if(value)
                v.fill_paint(grad)
            else
                v.fill_color off_color
            end
            v.fill
            v.stroke
        end

        text_color1   = color("52FAFE")
        text_color2   = color("B9CADE")
        vg.font_face("bold")
        vg.font_size h*0.6
        vg.text_align NVG::ALIGN_CENTER | NVG::ALIGN_MIDDLE
        if(value)
            vg.fill_color(text_color1)
        else
            vg.fill_color(text_color2)
        end
        vg.text(w*1.25/2,h/2,label.upcase)
    }

    function onMousePress(ev) {
        self.value = !self.value
        if(root)
            root.damage_item self
        end
        self.whenClick.call if self.whenClick
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
