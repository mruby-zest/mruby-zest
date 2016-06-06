Widget {
    Widget {
        id: lhs
        SearchBox {
        }
        Widget {
            SelColumn {
                title: "bank"
            }
            SelColumn {
                title: "type"
            }
            SelColumn {
                title: "tag"
            }
        }
    }
    Widget {
        id: rhs
        SelColumn {
            title: "preset"
            number: true
        }
        Widget {
            id: info_box
            Group {
                label: "author"
            }
            Group {
                label: "comments"
            }
        }
    }
    function layout(l)
    {
        selfBox = l.genBox :bank, self
        rhs_box = rhs.layout l
        lhs_box = rhs.layout l

        l.rightOf(rhs_box, lhs_box)
        l.sheq([rhs_box.w, selfBox.w], [0.5, -1.0], 0) 

        selfBox
    }
}
