Widget {
    id: side
    function class_name() { "ZynSidebar" }
    SidebarButton {
        id: partsetting
        label: "part settings"
    }
    Indent {
        id: part
        KitButtons {}
    }
    SidebarButton {
        id: browser
        label: "browser"
    }
    SidebarButton {
        id: mixer
        label: "mixer"
    }
    FancyButton {
        id: kitedit
        label: "kit editor"
    }
    Indent {
        id: kit
        KitButtons {}
    }
    FancyButton {
        id: arp
        label: "arp"
    }
    FancyButton {
        id: eff
        label: "effects"
    }
    FancyButton {
        id: add
        label: "add"
        value: true;
    }
    Indent {
        id: voices
        KitButtons { rows: 2}
    }
    FancyButton {
        id: subButton
        label: "sub"
    }
    FancyButton {
        id: padButton
        label: "pad"
    }

    function layout(l)
    {
        puts "LAYOUT HERE"
        selfBox = l.genBox :sidebar, side
        psBox   = partsetting.layout(l)
        partBox = part.layout(l)
        browBox = browser.layout(l)
        mixrBox = mixer.layout(l)
        kiteBox = kitedit.layout(l)
        kitsBox = kit.layout(l)
        arpsBox = arp.layout(l)
        effsBox = eff.layout(l)
        addsBox = add.layout(l)
        vcesBox = voices.layout(l)
        subsBox = subButton.layout(l)
        padsBox = padButton.layout(l)

        l.fixed(psBox,   selfBox, 0.1, 0,     0.8, 0.045)
        l.fixed(partBox, selfBox, 0.1, 0.05,  0.8, 0.19)
        l.fixed(browBox, selfBox, 0.1, 0.248, 0.8, 0.045)
        l.fixed(mixrBox, selfBox, 0.1, 0.3,   0.8, 0.045)
        l.fixed(kiteBox, selfBox, 0.1, 0.35,  0.8, 0.045)
        l.fixed(kitsBox, selfBox, 0.1, 0.405, 0.8, 0.187)
        l.fixed(arpsBox, selfBox, 0.1, 0.6,   0.8, 0.045)
        l.fixed(effsBox, selfBox, 0.1, 0.65,  0.8, 0.045)
        l.fixed(addsBox, selfBox, 0.1, 0.7,   0.8, 0.045)
        l.fixed(vcesBox, selfBox, 0.1, 0.75,  0.8, 0.13)
        l.fixed(subsBox, selfBox, 0.1, 0.88,  0.8, 0.045)
        l.fixed(padsBox, selfBox, 0.1, 0.94,  0.8, 0.045)

        selfBox
    }
}
