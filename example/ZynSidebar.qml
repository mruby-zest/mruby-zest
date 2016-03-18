Widget {
    id: side
    function class_name() { "ZynSidebar" }
    SidebarButton {
        id: partsetting
        x: 0.1*side.w
        y: 0
        w: side.w*0.8
        h: side.h*0.045
        label: "part settings"
    }
    Indent {
        id: part
        x: 0.1*side.w
        y: side.h*0.05
        w: side.w*0.8
        h: side.h*0.19
        KitButtons {
            x: 0.025*part.w 
            y: 0.025*part.h
            w: 0.95*part.w
            h: 0.9*part.h
        }
    }
    SidebarButton {
        id: browser
        x: 0.1*side.w
        y: side.h*0.248
        w: side.w*0.8
        h: side.h*0.045
        label: "browser"
    }
    SidebarButton {
        id: mixer
        x: 0.1*side.w
        y: side.h*0.3
        w: side.w*0.8
        h: side.h*0.045
        label: "mixer"
    }
    FancyButton {
        label: "kit editor"
        w: side.w*0.8
        h: side.h*0.045
        x: 0.1*side.w
        y: 0.35*side.h
    }
    Indent {
        id: kit
        x: 0.1*side.w
        y: side.h*0.405
        w: side.w*0.8
        h: side.h*0.187
        KitButtons {
            id: kitb
            x: 0.025*kit.w 
            y: 0.025*kit.h
            w: 0.95*kit.w
            h: 0.9*kit.h
        }
    }
    FancyButton {
        label: "arp"
        w: side.w*0.8
        h: side.h*0.045
        x: 0.1*side.w
        y: 0.6*side.h
    }
    FancyButton {
        label: "effects"
        w: side.w*0.8
        h: side.h*0.045
        x: 0.1*side.w
        y: 0.65*side.h
    }
    FancyButton {
        label: "adsynth"
        w: side.w*0.8
        h: side.h*0.045
        x: 0.1*side.w
        y: 0.7*side.h
        value: true;
    }
    Indent {
        id: voices
        x: 0.1*side.w
        y: side.h*0.75
        w: side.w*0.8
        h: side.h*0.13
        KitButtons {
            id: voice_buttons
            x: 0
            y: 0
            w: voices.w
            h: voices.h
        }
    }
    FancyButton {
        label: "subsynth"
        w: side.w*0.8
        h: side.h*0.045
        x: 0.1*side.w
        y: 0.88*side.h
    }
    FancyButton {
        label: "padsynth"
        w: side.w*0.8
        h: side.h*0.045
        x: 0.1*side.w
        y: 0.94*side.h
    }

    function layout(l)
    {
        #box = kitb.layout(l)
        #l.sheq([box.w], [1], kitb.w)
        #l.sheq([box.h], [1], kitb.h)
        #l.sheq([box.x], [1], kitb.x)
        #l.sheq([box.y], [1], kitb.y)
    }
}
