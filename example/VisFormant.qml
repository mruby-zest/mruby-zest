Widget {
    function draw(vg)
    {
        padfactor = 10
        bb = Draw::indent(Rect.new(0,0,w,h), padfactor, padfactor)
        background Theme::VisualBackground
        Draw::Grid::log_x(vg, 1, 20000, bb)
        Draw::Grid::linear_y(vg, 1, 20, bb)
    }
}
