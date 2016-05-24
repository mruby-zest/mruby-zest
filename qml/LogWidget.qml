Widget {
    property Int lines: 2

    function display_log(type, message, src)
    {
        self.label = message
        self.root.damage_item self
    }

    function onSetup(old)
    {
        self.root.log_widget = self
    }

    function draw(vg)
    {
        w=self.w
        h=self.h
        textColor = NVG.rgba(0x3a,0xc5,0xec,255);
        vg.font_face("bold")
        vg.font_size h/self.lines*0.8
        vg.text_align NVG::ALIGN_CENTER | NVG::ALIGN_MIDDLE
        vg.fill_color(textColor)
        vg.text_box(0,h/4,w,self.label.upcase)

    }
}
