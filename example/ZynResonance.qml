Widget {
    id: reson
    function refresh()
    {
        vis.refresh
    }
    VisResonance {
        id: vis
        extern: reson.extern + "respoints"
    }
    Indent {
        ZynResOptions {
            whenValue: lambda {reson.refresh}
            extern: reson.extern
        }
        function draw(vg)
        {
            vg.path do |v|
                v.rect(0,0,w,h)
                paint = v.linear_gradient(0,0,0,h,
                Theme::InnerGrad1, Theme::InnerGrad2)
                v.fill_paint paint
                v.fill
                v.stroke_color color(:black)
                v.stroke_width 1.0
                v.stroke
            end
        }
    }
    function layout(l)
    {
        selfBox = l.genBox :res, self
        chldBox = chBoxes(l)
        l.fixed(chldBox[0], selfBox, 0, 0.0, 1, 0.8)
        l.fixed(chldBox[1], selfBox, 0, 0.8, 1, 0.2)
        selfBox
    }
    function draw(vg)
    {
    }
}
