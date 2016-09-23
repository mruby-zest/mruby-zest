Widget {
    id: dyn
    VisFilter {
        id: vis
        extern: dyn.extern + "filterpars/response"
    }
    ZynDyFilter {
        whenModified: lambda { vis.refresh }
        extern: dyn.extern + "filterpars/"
    }
    function layout(l)
    {
        Draw::Layout::vfill(l, self_box(l), chBoxes(l), [0.5, 0.5])
    }
}
