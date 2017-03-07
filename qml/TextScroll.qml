Widget {
    id: text
    property signal action: nil;
    property Color  textColor: Theme::TextColor
    property Int    lines: 30
    property Object valueRef: nil
    property Int    off: 0



    function class_name() { "TextScroll" }

    ScrollBar {
        id: scroll
        whenValue: lambda { text.tryScroll }
    }
    
    function onScroll(ev)
    {
        scroll.onScroll(ev)
    }

    function num_lines()
    {
        ind = 0
        self.label.each_line do |l|
            ind += 1
        end
        ind
    }

    function tryScroll()
    {
        ln = num_lines()
        start = (1-scroll.value)*(ln-lines)
        start = start.to_i
        if(start != self.off)
            self.off = start
            damage_self
        end
    }

    function layout(l, selfBox)
    {
        children[0].fixed(l, selfBox, 0.00, 0, 0.02, 1.0)
        selfBox
    }

    function draw(vg)
    {
        background Theme::VisualBackground
        input  = self.label

        hh = h/lines
        vg.font_face("bold")
        vg.font_size hh
        vg.text_align NVG::ALIGN_LEFT | NVG::ALIGN_MIDDLE
        vg.fill_color(textColor)

        ind = 0
        input.each_line do |l|
            ii = ind-self.off
            break if ii >= self.lines
            vg.text(10+0.02*w, hh/2+hh*ii, l) if ii >= 0
            ind += 1
        end

    }
}
