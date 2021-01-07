Widget {
    ToggleButton {
        id: fn
        label: "fine"
        layoutOpts: [:no_constraint];

        function animate()
        {
            if(fn.value != root.fine_mode)
                fn.value = root.fine_mode
                fn.damage_self
            end
        }
    }
    HSlider {type: :float; extern: "/Volume"; height: 0.8; label: "volume"; }
    Button  {layoutOpts: [:no_constraint]; label: "nrpn" }
    HSlider {extern: "/Pkeyshift"; height: 0.8; label: "key shift" }

    function layout(l, selfBox) {
        padw  = 1.0/256
        padw2 = 0.5-2*padw
        padh = 1.0/32
        padh2 = 0.5-2*padh
        children[0].fixed(l, selfBox, 0.0+padw, 0.0+padh, padw2, padh2)
        children[1].fixed(l, selfBox, 0.5+padw, 0.0+padh, padw2, padh2)
        children[2].fixed(l, selfBox, 0.0+padw, 0.5+padh, padw2, padh2)
        children[3].fixed(l, selfBox, 0.5+padw, 0.5+padh, padw2, padh2)

        selfBox
    }
}
