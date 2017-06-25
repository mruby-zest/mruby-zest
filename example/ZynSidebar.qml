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
        KitButtons { sym: :part}
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
    SidebarButton {
        id: kitedit
        label: "kits"
        whenClick: lambda { side.set_content :kits }
    }
    Indent {
        id: kit
        KitButtons { sym: :kit}
    }
    SidebarButton {
        id: arp
        label: "midi learn"
        whenClick: lambda { side.set_content :automate }
    }
    SidebarButton {
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
        KitButtons { sym: :voice; rows: 2}
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

    function set_content(type, flag=nil)
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

        parent.set_content(type) if flag.nil? && parent.respond_to?(:set_content)
    }

    function set_view()
    {
        prt  = root.get_view_pos(:part)
        kid  = root.get_view_pos(:kit)
        typ  = root.get_view_pos(:view)
        padButton.extern = "/part#{prt}/kit#{kid}/Ppadenabled"
        subButton.extern = "/part#{prt}/kit#{kid}/Psubenabled"
        add.extern       = "/part#{prt}/kit#{kid}/Padenabled"
        set_content(typ, true)
    }

    function onSetup(old=nil)
    {
        set_view
    }

    function layout(l, selfBox)
    {
        partsetting.fixed(l, selfBox, 0.1, 0,     0.8, 0.045)
        part.fixed(l,        selfBox, 0.1, 0.05,  0.8, 0.19)
        browser.fixed(l,     selfBox, 0.1, 0.248, 0.8, 0.045)
        mixer.fixed(l,       selfBox, 0.1, 0.3,   0.8, 0.045)
        kitedit.fixed(l,     selfBox, 0.1, 0.35,  0.8, 0.045)
        kit.fixed(l,         selfBox, 0.1, 0.405, 0.8, 0.187)
        arp.fixed(l,         selfBox, 0.1, 0.6,   0.8, 0.045)
        eff.fixed(l,         selfBox, 0.1, 0.65,  0.8, 0.045)
        add.fixed(l,         selfBox, 0.1, 0.7,   0.8, 0.045)
        voices.fixed(l,      selfBox, 0.1, 0.76,  0.8, 0.10)
        subButton.fixed(l,   selfBox, 0.1, 0.88,  0.8, 0.045)
        padButton.fixed(l,   selfBox, 0.1, 0.94,  0.8, 0.045)

        selfBox
    }
}
