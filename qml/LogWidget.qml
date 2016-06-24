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
        textColor  = color("3ac5ec")
        splitColor = color("133A4C")

        vg.path do |vg|
            vg.move_to(0,0.5*h)
            vg.line_to(w,0.5*h)
            vg.stroke_width 2.0
            vg.stroke_color splitColor
            vg.stroke
        end

        vg.font_face("bold")
        vg.font_size h/self.lines*0.8
        vg.text_align NVG::ALIGN_LEFT | NVG::ALIGN_MIDDLE
        vg.fill_color(textColor)
        vg.text_box(0,h/4,w,self.label.upcase)
    }
}
