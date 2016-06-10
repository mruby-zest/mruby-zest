Valuator {
    property Symbol orientation: :horizontal

    value: 0.6
    function draw(vg)
    {
        vg.path do |v|
            v.rect(0,0,w,h)
            v.fill_color Theme::ScrollInactive
            v.fill
        end
        if(orientation == :horizontal)
            vg.path do |v|
                v.rect(0,0,self.w*self.value,h)
                v.fill_color Theme::ScrollActive
                v.fill
            end
        else
            vg.path do |v|
                v.rect(0,@h*(1-value),@w,@h*value)
                v.fill_color Theme::ScrollActive
                v.fill
            end
        end
    }
}
