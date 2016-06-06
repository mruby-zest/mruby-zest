Widget {
    property Bool grid: true;
    function draw(vg)
    {
        pad  = 1/32
        pad2 = (1-2*pad)
        box = Rect.new(w*pad, h*pad, w*pad2, h*pad2)

        background Theme::VisualBackground
        if(grid)
            Draw::Grid::linear_x(vg,0,10,box, 0.3)
            Draw::Grid::linear_y(vg,0,10,box, 0.4)
        end
        Draw::WaveForm::sin(vg, box)
    }
}
