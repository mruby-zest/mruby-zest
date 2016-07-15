Widget {
    id: kit_item
    property Array weights: [0.05, 0.10, 0.10, 0.10, 0.05, 0.10, 0.10, 0.10, 0.30]

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
        extern: kit_item.extern + "Pminkey"
        label: "0"
    }
    ZynKitKeyButton {
        extern: kit_item.extern
    }
    HSlider {
        extern: kit_item.extern + "Pmaxkey"
    }
    FancyButton {
        extern: kit_item.extern + "Padenabled"
        layoutOpts: [:no_constraint];
        label: "edit"
        whenClick: lambda {
            rt = kit_item.root
            rt.set_view_pos(:view, :add_synth)
            rt.set_view_pos(:kit, kit_item.label.to_i)
            rt.change_view
        }
    }
    FancyButton {
        extern: kit_item.extern + "Psubenabled"
        layoutOpts: [:no_constraint];
        label: "edit"
        whenClick: lambda {
            rt = kit_item.root
            rt.set_view_pos(:view, :sub_synth)
            rt.set_view_pos(:kit, kit_item.label.to_i)
            rt.change_view
        }
    }
    FancyButton {
        extern: kit_item.extern + "Ppadenabled"
        layoutOpts: [:no_constraint];
        label: "edit"
        whenClick: lambda {
            rt = kit_item.root
            rt.set_view_pos(:view, :pad_synth)
            rt.set_view_pos(:kit, kit_item.label.to_i)
            rt.change_view
        }
    }
    Selector {
        extern: kit_item.extern + "Psendtoparteffect"
        layoutOpts: [:no_constraint];
        label: "off"
    }

    function class_name() { "kitrow" }
    function layout(l) {
        Draw::Layout::hfill(l, self_box(l), chBoxes(l), kit_item.weights, 0, 3)
    }

    function onSetup(old=nil)
    {
        children.each do |ch|
            ch.extern()
        end
    }
}
