Widget {
    function draw(vg)
    {
        vg.path do |v|
            v.rect(0,0,self.w,self.h)
            v.fill_color color("8f600f")
            v.fill
        end
    }
}
