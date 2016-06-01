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
}
