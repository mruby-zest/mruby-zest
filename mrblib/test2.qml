Window {
    id: window

    property String url: "/foo/bar/"

    label: "Test Window"

    Button {
        onAction: DataModel.emit(window.url+"blam")
    }

    Knob {
        valueRef: DataModel.obtain(window.url+"blaz")
    }
}
