Widget {
    property Color bg: color("8f600f")
    property Float pad: 0.0
    function draw(vg)
    {
        return if bg.nil?
        pad2 = (1-2*pad)
        vg.path do |v|
            v.rect(pad*w,pad*h,pad2*w,pad2*h)
            v.fill_color self.bg
            v.fill
        end
    }
}
