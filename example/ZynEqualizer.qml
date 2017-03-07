Widget {
    id: eq
    VisEq {
        id: vis
        extern: eq.extern + "EQ/coeff"
    }
    Widget {
        ParModuleRow {
            Knob {
                extern: eq.extern + "Pvolume"
                label: "vol"
            }
            NumEntry {
                id: fil_sel
                whenValue: lambda {eq.change_filter}
                label: "filter id"
                minimum: 1
                maximum: 8
                offset:  1
                value:   1
            }
        }
        Swappable {
            id: filter
        }
        function layout(l, selfBox) {
            Draw::Layout::vpack(l, selfBox, children)
        }

    }
    function draw(vg) {
        Draw::GradBox(vg, Rect.new(0, 0, w, h))
    }

    function layout(l, selfBox) {
        Draw::Layout::hpack(l, selfBox, children)
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
