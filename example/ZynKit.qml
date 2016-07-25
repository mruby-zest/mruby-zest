Widget {
    id: kit
    property Object valueRef: nil

    onExtern: {
        kit.valueRef = OSC::RemoteParam.new($remote, kit.extern + "Pkitmode")
        kit.valueRef.mode = :options
        kit.valueRef.callback = lambda {|x| kit.get_mode(x) }

    }

    function get_mode(x)
    {
        (0..2).each do |i|
            children[0].children[i].value = i == x
            children[0].children[i].damage_self
        end
    }

    function set_mode(x)
    {
        kit.valueRef.value = x
        get_mode(x)
    }

    Widget {
        Button {
            label: "No Kits";
            whenValue: lambda { kit.set_mode(0) }
        }
        Button {
            label: "Multi-Kit";
            whenValue: lambda { kit.set_mode(1) }
        }
        Button {
            label: "Single-Kit";
            whenValue: lambda { kit.set_mode(2) }
        }
        ToggleButton {
            id: drum;
            extern: kit.extern + "Pdrummode"
            label: "drum mode"
        }
        function layout(l) {
            Draw::Layout::tabpack(l, self, drum)
        }
    }

    ZynKitTable {
        extern: kit.extern
    }

    function layout(l) {
        Draw::Layout::vfill(l, self_box(l), chBoxes(l), [0.05,0.95], 1, 2)
    }
}
