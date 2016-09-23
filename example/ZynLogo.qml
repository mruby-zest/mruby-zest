Widget {
    function draw(vg)
    {
        #background color("123456")
        #vg.path do |v|
        #    v.rect(0, 0, w, h)
        #    v.fill_color(NVG.rgba(0xaa, 0xaa, 0xaa, 255))
        #    v.fill
        #end
        logo_top = color("4DC3C7")
        logo_bot = color("56C0A5")

        vg.path do |v|
            l = 0.4*w
            v.move_to(0,0)
            v.line_to(l,      0.1*h)
            v.line_to(l*0.75, 0.6*h)
            v.close_path
            v.fill_color logo_top
            v.fill
        end

        vg.path do |v|
            l = 0.4*w
            v.move_to(l,h)
            v.line_to(0,      0.9*h)
            v.line_to(l*0.25, 0.4*h)
            v.close_path
            v.fill_color logo_bot
            v.fill
        end

        vg.font_face("bold")
        vg.font_size h*0.8
        vg.text_align NVG::ALIGN_LEFT | NVG::ALIGN_MIDDLE
        vg.fill_color logo_top
        vg.text(w*1/2,h/2,"ZYN")
    }

    function onMousePress(m)
    {
        root.set_view_pos(:view, :about)
        root.change_view
    }
}
