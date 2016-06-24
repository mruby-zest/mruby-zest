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

    Button {
        id: close
        label: "x"
        layoutOpts: [:no_constraint]
    }

    Button {
        id: minimize
        label: "-"
        layoutOpts: [:no_constraint]
        textScale: 1.2
    }

    function layout(l)
    {
        selfBox = l.genBox :header, head

        logoBox = logo.layout(l)
        menuBox = menuIndent.layout(l)
        statBox = status.layout(l)
        shrtBox = shortcuts.layout(l)
        metrBox = vumeter.layout(l)
        paniBox = panic.layout(l)
        clseBox = close.layout(l)
        miniBox = minimize.layout(l)

        l.fixed(logoBox, selfBox, 0.016, 0.2,  0.080, 0.6)
        l.fixed(menuBox, selfBox, 0.100, 0.15, 0.112, 0.7)
        l.fixed(statBox, selfBox, 0.220, 0.15, 0.520, 0.7)
        l.fixed(shrtBox, selfBox, 0.745, 0.15, 0.160, 0.7)
        l.fixed(metrBox, selfBox, 0.910, 0.15, 0.015, 0.7)
        l.fixed(paniBox, selfBox, 0.930, 0.15, 0.040, 0.7)
        l.fixed(clseBox, selfBox, 0.975, 0.15, 0.015, 0.3)
        l.fixed(miniBox, selfBox, 0.975, 0.54, 0.015, 0.3)

        selfBox
    }
}
