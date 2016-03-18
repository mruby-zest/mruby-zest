Window {
    id: window

    property String url: "/foo/bar/"

    label: "Test Window"

    Button {
        label: "hello button"
        onAction: puts("hello world")
    }

    Knob {
        label: "knob"
        valueRef: nil
    }
}

//Object {
//    property Layout layout: parent.layout
//
//    property Children children: []
//
//    property String label: ""
//
//    property Rectangle redrawArea: children.redrawArea+selfRedraw
//
//    property Bool prepared: children.prepared && selfPrepared
//    property Bool selfPrepared: true
//
//    function draw()
//    {
//    }
//
//    function layout()
//    {
//        Layout.applyPack children
//    }
//}
