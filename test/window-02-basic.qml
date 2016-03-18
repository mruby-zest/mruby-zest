Window {
    label: "Window-02-basic.qml"
    w: 120
    h: 200
    id: window
    Slider {
        label: "slider1"
        x: 0
        y: 0
        w: window.w/2
        h: window.h
    }
    Slider {
        label: "slider2"
        x: window.w/2
        y: 0
        w: window.w/2
        h: window.h
    }
}
