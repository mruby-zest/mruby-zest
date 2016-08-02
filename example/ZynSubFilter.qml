Widget {
    id: subfl
    //visual
    Swappable {
        id: edit
        extern: subfl.extern + "GlobalFilterEnvelope/"
        content: Qml::ZynEnvEdit
    }
    Widget {
        ZynAnalogFilter {
            id: filedit
            toggleable: subfl.extern + "PGlobalFilterEnabled"
            extern: subfl.extern + "GlobalFilter/"
        }
        ZynFilterEnv {
            extern: subfl.extern+"GlobalFilterEnvelope/"
            whenModified: lambda { edit.children[0].refresh }
        }
        function layout(l) {
            Draw::Layout::hpack(l, self_box(l), chBoxes(l))
        }
    }
    function layout(l) {
        Draw::Layout::vfill(l, self_box(l), chBoxes(l), [0.6, 0.4])
    }
    function onSetup(old=nil) {
        filedit.remove_sense()
    }
}
