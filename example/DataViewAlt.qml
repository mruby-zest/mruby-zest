Widget {
    id: draw_alt
    layer: 1
    property Array points: draw_alt.mk_points

    function mk_points()
    {
        pts = []
        while(pts.length < 128)
            pts << 0
        end
        pts
    }

    function draw(vg)
    {
        pad = 5
        box = Rect.new(pad, pad, w-2*pad, h-2*pad)
        Draw::WaveForm::plot(vg, self.points, box, false)
    }
}
