Valuator {
    property Symbol orientation: :horizontal
    property Float  bar_size: 0.1

    function draw(vg)
    {
        self.dragScale = h*(1-bar_size)
        vg.path do |v|
            v.rect(0,0,w,h)
            v.fill_color Theme::ScrollInactive
            v.fill
        end
        domain = 1.0-bar_size
        center = 0.5*bar_size + (1-value)*domain
        if(orientation == :horizontal)
            vg.path do |v|
                v.rect(w*(center-0.5*bar_size),0,w*bar_size,h)
                v.fill_color Theme::ScrollActive
                v.fill
            end
        else
            vg.path do |v|
                v.rect(0,@h*(center-0.5*bar_size),@w,@h*bar_size)
                v.fill_color Theme::ScrollActive
                v.fill
            end
        end
    }
}
