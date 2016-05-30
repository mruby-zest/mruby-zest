Widget {
    function draw(vg)
    {
        pad  = 1/32
        pad2 = (1-2*pad)
        box = Rect.new(w*pad, h*pad, w*pad2, h*pad2)
        Draw::Grid::linear_x(vg,0,10,box)
        Draw::Grid::linear_y(vg,0,10,box)
        Draw::WaveForm::sin(vg, box)
    }
}
