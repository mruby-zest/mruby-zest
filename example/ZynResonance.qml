Widget {
    function draw(vg)
    {
        vg.path do |v|
            v.rect(0,0,w,h)
            v.fill_color   Theme::VisualBackground
            v.fill
        end

        bb = Rect.new(0,0,w,h)
        Draw::Grid::linear_x(vg, 0, 1, bb)
        Draw::Grid::linear_y(vg, 0, 1, bb)
    }
}
