Widget {
    id: head
    function class_name() {"ZynHeader"}
    Text {
        id: logo
        label: "Zyn"

        function draw(vg)
        {
            #vg.path do |v|
            #    v.rect(0, 0, w, h)
            #    v.fill_color(NVG.rgba(0xaa, 0xaa, 0xaa, 255))
            #    v.fill
            #end
            vg.font_face("bold")
            vg.font_size h*0.8
            vg.text_align NVG::ALIGN_LEFT | NVG::ALIGN_MIDDLE
            vg.fill_color(NVG.rgba(0xff, 0xff, 0xff, 255))
            vg.text(w/16,h/2,label.upcase)
        }

        layoutOpts: [:ignoreAspect]
    }
    Indent {
        id: menuIndent
        MainMenu {
            //label: "midi learn"
            //layoutOpts: [:no_constraint]
        }
    }

    Indent {
        id: status

        LogWidget {
            label: "console log"
        }
    }

    Indent {
        id: shortcuts
        //Text {
        //    x: 0
        //    y: 0
        //    w: shortcuts.w/4
        //    h: shortcuts.h/2
        //    label: "fine detune"
        //}
        //Text {
        //    x: shortcuts.w/4
        //    y: 0
        //    w: shortcuts.w/4
        //    h: shortcuts.h/2
        //    label: "master volume"
        //}
        //Text {
        //    x: shortcuts.w/2
        //    y: 0
        //    w: shortcuts.w/4
        //    h: shortcuts.h/2
        //    label: "volume meters"
        //}
        //Text {
        //    x: shortcuts.w*3/4
        //    y: 0
        //    w: shortcuts.w/4
        //    h: shortcuts.h/2
        //    label: "panic"
        //}
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
        paniBox = panic.layout(l)
        clseBox = close.layout(l)
        miniBox = minimize.layout(l)

        l.fixed(logoBox, selfBox, 0.016, 0.2,  0.16,  0.6)
        l.fixed(menuBox, selfBox, 0.192, 0.15, 0.112, 0.7)
        l.fixed(statBox, selfBox, 0.314, 0.15, 0.42,  0.7)
        l.fixed(shrtBox, selfBox, 0.745, 0.15, 0.17,  0.7)
        l.fixed(paniBox, selfBox, 0.92, 0.15, 0.05,  0.7)
        l.fixed(clseBox, selfBox, 0.975, 0.15, 0.015,  0.3)
        l.fixed(miniBox, selfBox, 0.975, 0.54, 0.015,  0.3)

        selfBox
    }
}
