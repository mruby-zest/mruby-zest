Widget {
    id: title_bar
    function draw(vg)
    {
        vg.path do |v|
            v.rect(0,0,self.w,self.h)
            v.fill_color Theme::TitleBar
            v.fill
        end
    }
    Text {
        id: title
        label: title_bar.label
        height: 0.8
    }
}
