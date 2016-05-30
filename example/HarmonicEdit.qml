Widget {
    function draw(vg)
    {
        vg.path do |v|
            v.rect(0,0,self.w,self.h)
            v.fill_color color("ff600f")
            v.fill
        end
    }
}
