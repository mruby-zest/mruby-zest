Widget {
    id: subfl
    //visual
    Swappable {
        extern: subfl.extern + "GlobalFilterEnvelope/"
        content: Qml::ZynEnvEdit
    }
    Widget {
        ZynAnalogFilter {
            extern: subfl.extern + "GlobalFilter/"
        }
        ZynFilterEnv {extern: subfl.extern+"GlobalFilterEnvelope/"}
        function layout(l) {
            Draw::Layout::hpack(l, self_box(l), chBoxes(l))
        }
    }
    function layout(l) {
        Draw::Layout::vfill(l, self_box(l), chBoxes(l), [0.6, 0.4])
    }
}
