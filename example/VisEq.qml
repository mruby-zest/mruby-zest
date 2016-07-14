Widget {
    function draw(vg)
    {
        fixedpad = 5
        pad  = 0
        pad2 = (1-2*pad)
        box = Rect.new(w*pad  + fixedpad,   h*pad  + fixedpad,
                       w*pad2 - 2*fixedpad, h*pad2 - 2*fixedpad)
        vg.path do
            vg.rect(box.x, box.y, box.w, box.h)
            vg.fill_color Theme::VisualBackground
            vg.fill
        end
        Draw::Grid::log_x(vg, 1, 20000, box)
        Draw::Grid::linear_y(vg, 1, 20, box)
    }
}
