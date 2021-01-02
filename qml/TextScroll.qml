Widget {
    id: text
    property signal action: nil;
    property Color  textColor: Theme::TextColor
    // Number of text lines visible in the widget.
    property Int    lines: 30
    property Object valueRef: nil
    property Int    off: 0

    // Internal property, not meant to be changed from outside.
    property Int _content_lines: -1

    function class_name() { "TextScroll" }

    ScrollBar {
        id: scroll
        bar_size: scrollbar_size()
        whenValue: lambda { text.tryScroll }
    }

    function scrollbar_size()
    {
        compute_content_lines()
        ratio = [0.05, [1.0, lines.to_f / _content_lines].min].max
        ratio
    }
    
    function onScroll(ev)
    {
        return if !scroll.active
        scroll.updatePos(-ev.dy.to_f/(_content_lines-lines))
    }

    function compute_content_lines()
    {
        if (self._content_lines > -1)
          return
        end
        self._content_lines = 0
        self.label.each_line do |l|
            self._content_lines += 1
        end
        self._content_lines
    }

    function tryScroll()
    {
        if ((_content_lines - lines) <= 0)
          self.off = 0
          damage_self
          return
        end
        start = (1.0-scroll.value)*(_content_lines-lines) + 0.5
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
