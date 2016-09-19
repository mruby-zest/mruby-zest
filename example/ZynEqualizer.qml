Widget {
    id: eq
    VisEq {
        id: vis
        extern: eq.extern + "EQ/coeff"
    }
    Widget {
        NumEntry {
            id: fil_sel
            whenValue: lambda {eq.change_filter}
            minimum: 1
            maximum: 8
            offset:  1
            value:   1
        }
        Swappable {
            id: filter
        }
        function layout(l) {
            Draw::Layout::vpack(l, self_box(l), chBoxes(l))
        }

    }
    function draw(vg) {
        Draw::GradBox(vg, Rect.new(0, 0, w, h))
    }

    function layout(l) {
        Draw::Layout::hpack(l, self_box(l), chBoxes(l))
    }

    function change_filter()
    {
        filter.extern  = eq.extern + "EQ/filter#{fil_sel.value-1}/"
        filter.content = Qml::ZynEqFilter
        filter.children[0].whenValue = lambda { vis.refresh }
    }

    function onSetup(old=nil)
    {
        change_filter
    }

}
