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
    function layout(l, selfBox) {
        Draw::Layout::vfill(l, selfBox, children, [0.5, 0.5])
    }
}
