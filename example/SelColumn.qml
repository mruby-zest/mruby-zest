Widget {
    property Bool number: false

    function draw(vg)
    {
        pad  = 1/128.0
        pad2 = (1-2*pad)
        vg.path do |v|
            v.rect(pad*w,pad*h,pad2*w,pad2*h)
            v.fill_color color("123456")
            v.fill
        end
    }
}
