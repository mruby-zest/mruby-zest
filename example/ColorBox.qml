Widget {
    property Color bg: color("8f600f")
    function draw(vg)
    {
        vg.path do |v|
            v.rect(0,0,self.w,self.h)
            v.fill_color self.bg
            v.fill
        end
    }
}
