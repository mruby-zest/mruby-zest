Widget {
    id: head
    function class_name() {"ZynHeader"}
    ZynLogo {id: logo}
    MainMenu {
        id: menuIndent
    }

    Indent {
        pad: 0.01
        id: status

        LogWidget {
            label: "console log"
        }
    }

    ZynHeaderParams {
        id: shortcuts
    }

    VuMeter {
        id: vumeter
    }

    PanicButton {
        id: panic
        layoutOpts: [:no_constraint]
    }

    Widget { id: close }
    Widget { id: minimize }

    //Button {
    //    id: close
    //    label: "x"
    //    layoutOpts: [:no_constraint]
    //}

    //Button {
    //    id: minimize
    //    label: "-"
    //    layoutOpts: [:no_constraint]
    //    textScale: 1.2
    //}

    function layout(l, selfBox) {
        logo.fixed(l,       selfBox, 0.016, 0.22,  0.070, 0.56)
        menuIndent.fixed(l, selfBox, 0.100, 0.15, 0.112, 0.7)
        status.fixed(l,     selfBox, 0.220, 0.15, 0.520, 0.7)
        shortcuts.fixed(l,  selfBox, 0.745, 0.15, 0.160, 0.7)
        vumeter.fixed(l,    selfBox, 0.910, 0.15, 0.015, 0.7)
        panic.fixed(l,      selfBox, 0.930, 0.15, 0.040, 0.7)
        close.fixed(l,      selfBox, 0.975, 0.15, 0.015, 0.3)
        minimize.fixed(l,   selfBox, 0.975, 0.54, 0.015, 0.3)

        selfBox
    }
}
