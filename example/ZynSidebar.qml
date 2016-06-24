Widget {
    id: side
    function class_name() { "ZynSidebar" }
    SidebarButton {
        id: partsetting
        label: "part settings"
        whenClick: lambda { side.set_content :part }
    }
    Indent {
        id: part
        KitButtons {}
    }
    SidebarButton {
        id: browser
        label: "browser"
        whenClick: lambda { side.set_content :banks }
    }
    SidebarButton {
        id: mixer
        label: "mixer"
        whenClick: lambda { side.set_content :mixer }
    }
    FancyButton {
        id: kitedit
        label: "kit editor"
        whenClick: lambda { side.set_content :kits }
    }
    Indent {
        id: kit
        KitButtons {}
    }
    SidebarButton {
        id: arp
        label: "midi learn"
        whenClick: lambda { side.set_content :midi_learn }
    }
    FancyButton {
        id: eff
        label: "effects"
        whenClick: lambda { side.set_content :effects }
    }
    FancyButton {
        id: add
        label: "add"
        value: true;
        whenClick: lambda { side.set_content :add_synth }
    }
    Indent {
        id: voices
        KitButtons { rows: 2}
    }
    FancyButton {
        id: subButton
        label: "sub"
        whenClick: lambda { side.set_content :sub_synth }
    }
    FancyButton {
        id: padButton
        label: "pad"
        whenClick: lambda { side.set_content :pad_synth }
    }

    function set_content(type)
    {
        tabs = [:part, :banks, :mixer, :kits, :midi_learn, :effects,
                :add_synth, :sub_synth, :pad_synth]
        ind = 0
        self.children.each do |ch|
            if([Qml::FancyButton, Qml::SidebarButton].include? ch.class)
                n = (type == tabs[ind])
                if(n != ch.value)
                    ch.value = n
                    root.damage_item ch if root
                end
                ind += 1
            end
        end

        parent.set_content(type) if parent.respond_to? :set_content
    }

    function layout(l)
    {
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
        l.fixed(vcesBox, selfBox, 0.1, 0.76,  0.8, 0.10)
        l.fixed(subsBox, selfBox, 0.1, 0.88,  0.8, 0.045)
        l.fixed(padsBox, selfBox, 0.1, 0.94,  0.8, 0.045)

        selfBox
    }
}
