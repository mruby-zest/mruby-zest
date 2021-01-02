Valuator {
    // Relative size of the scroll bar handle to the full length.
    property Float  bar_size: 0.1
    property Symbol style: :normal

    function draw(vg)
    {
        if(self.style == :overlay)
            draw_overlay(vg)
        else
            draw_normal(vg)
        end
    }
    function draw_overlay(vg)
    {
        pad = 1
        domain = 1.0-bar_size
        if(vertical)
            center = 0.5*bar_size + (1-value)*domain
            self.dragScale = h*(1-bar_size)
            vg.path do |v|
                v.rect(pad,pad+@h*(center-0.5*bar_size),
                    @w-2*pad,@h*bar_size-2*pad)
                v.fill_color color("56c0a5")
                v.fill
            end
        else
            center = 0.5*bar_size + value*domain
            self.dragScale = w*(1-bar_size)
            vg.path do |v|
                v.rect(pad+w*(center-0.5*bar_size),pad,
                w*bar_size-2*pad,h-2*pad)
                v.fill_color color("56c0a5")
                v.fill
            end
        end
    }
    function draw_normal(vg)
    {
        pad = 1
        vg.path do |v|
            v.rect(pad,pad,w-2*pad,h-2*pad)
            v.fill_color Theme::ScrollInactive
            v.fill
        end
        domain = 1.0-bar_size
        if(vertical)
            center = 0.5*bar_size + (1-value)*domain
            self.dragScale = h*(1-bar_size)
            vg.path do |v|
                v.rect(pad,pad+@h*(center-0.5*bar_size),
                    @w-2*pad,@h*bar_size-2*pad)
                v.fill_color Theme::ScrollActive
                v.fill
            end
        else
            center = 0.5*bar_size + value*domain
            self.dragScale = w*(1-bar_size)
            vg.path do |v|
                v.rect(pad+w*(center-0.5*bar_size),pad,
                w*bar_size-2*pad,h-2*pad)
                v.fill_color Theme::ScrollActive
                v.fill
            end
        end
    }
}
