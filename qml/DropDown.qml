Widget {
    property String extern: ""
    property String text:   "text";
    function draw(vg)
    {
        #puts("draw dropdown...")
        vg.path do |v|
            v.rect(w/4, h/4, w/2, h/2)
            v.fill_color(NVG.rgba(0, 0, 128, 255))
            v.fill
        end
    }
}
