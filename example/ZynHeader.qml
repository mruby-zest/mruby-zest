Widget {
    id: head
    function class_name() {"ZynHeader"}
    Text {
        id: logo
        label: "Zyn"
        x: 0.016*head.w
        w: 0.16*head.w
        y: head.h*0.2
        h: head.h*0.6

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
    }
    Indent {
        id: menu
        x: 0.192*head.w
        y: head.h*0.15
        w: head.w*0.112
        h: head.h*0.7
        Button {
            x: 0
            y: 0
            w: menu.w
            h: menu.h
            label: "midi learn"
        }
    }

    Indent {
        id: status
        x: 0.314*head.w
        y: head.h*0.15
        w: head.w*0.32
        h: head.h*0.7

        LogWidget {
            x: 0
            y: 0
            w: status.w
            h: status.h
            label: "console log"
        }
    }

    Indent {
        id: shortcuts
        x: 0.645*head.w
        y: head.h*0.15
        w: head.w*0.32
        h: head.h*0.7
        Text {
            x: 0
            y: 0
            w: shortcuts.w/4
            h: shortcuts.h/2
            label: "fine detune"
        }
        Text {
            x: shortcuts.w/4
            y: 0
            w: shortcuts.w/4
            h: shortcuts.h/2
            label: "master volume"
        }
        Text {
            x: shortcuts.w/2
            y: 0
            w: shortcuts.w/4
            h: shortcuts.h/2
            label: "volume meters"
        }
        Text {
            x: shortcuts.w*3/4
            y: 0
            w: shortcuts.w/4
            h: shortcuts.h/2
            label: "panic"
        }
    }
}
