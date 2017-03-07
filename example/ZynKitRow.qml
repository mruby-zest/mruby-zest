Widget {
    id: kit_item
    property Array weights: [0.05, 0.10, 0.10, 0.10, 0.05, 0.10, 0.10, 0.10, 0.30]
    property Int   kitnum: 0

    function set_active(a)
    {
        minkey.active = a
        maxkey.active = a
        damage_self
    }

    ToggleButton {
        extern: kit_item.extern + "Penabled"
        label: kit_item.label;
        layoutOpts: [:no_constraint]
    }
    TextLine {
        extern: kit_item.extern + "Pname"
        label: "kit name"
    }
    HSlider {
        id: minkey
        extern: kit_item.extern + "Pminkey"
        label: "0"
    }
    ZynKitKeyButton {
        extern: kit_item.extern
        whenValue: lambda {
            minkey.refresh
            maxkey.refresh
        }
    }
    HSlider {
        id: maxkey
        extern: kit_item.extern + "Pmaxkey"
    }
    FancyButton {
        id: add
        extern: kit_item.extern + "Padenabled"
        layoutOpts: [:no_constraint];
        label: "edit"
        whenClick: lambda {
            if(!add.children[0].value)
                $remote.action(add.extern, true)
            end
            rt = kit_item.root
            rt.set_view_pos(:view, :add_synth)
            rt.set_view_pos(:kit, kit_item.kitnum)
            rt.change_view
        }
    }
    FancyButton {
        id: sub
        extern: kit_item.extern + "Psubenabled"
        layoutOpts: [:no_constraint];
        label: "edit"
        whenClick: lambda {
            if(!sub.children[0].value)
                $remote.action(sub.extern, true)
            end
            rt = kit_item.root
            rt.set_view_pos(:view, :sub_synth)
            rt.set_view_pos(:kit, kit_item.kitnum)
            rt.change_view
        }
    }
    FancyButton {
        id: pad_but
        extern: kit_item.extern + "Ppadenabled"
        layoutOpts: [:no_constraint];
        label: "edit"
        whenClick: lambda {
            if(!pad_but.children[0].value)
                $remote.action(pad_but.extern, true)
            end
            rt = kit_item.root
            rt.set_view_pos(:view, :pad_synth)
            rt.set_view_pos(:kit, kit_item.kitnum)
            rt.change_view
        }
    }
    Selector {
        extern: kit_item.extern + "Psendtoparteffect"
        layoutOpts: [:no_constraint];
        label: "off"
    }

    function class_name() { "kitrow" }
    function layout(l, selfBox) {
        Draw::Layout::hfill(l, selfBox, children, kit_item.weights, 0, 3)
    }

    function onSetup(old=nil)
    {
        children.each do |ch|
            ch.extern()
        end
    }
}
