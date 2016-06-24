Valuator {
    property Float  bar_size: 0.1

    function draw(vg)
    {
        pad = 1
        vg.path do |v|
            v.rect(pad,pad,w-2*pad,h-2*pad)
            v.fill_color Theme::ScrollInactive
            v.fill
        end
        domain = 1.0-bar_size
        center = 0.5*bar_size + (1-value)*domain
        if(vertical)
            self.dragScale = h*(1-bar_size)
            vg.path do |v|
                v.rect(pad,pad+@h*(center-0.5*bar_size),
                    @w-2*pad,@h*bar_size-2*pad)
                v.fill_color Theme::ScrollActive
                v.fill
            end
        else
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
