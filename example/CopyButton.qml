Button {
    id: copy_button

    onExtern: {
        copy_button.tooltip = "copy from " + copy_button.extern.to_s
    }

    function layout(l, selfBox) {
        l.aspect(selfBox, 1, 1)
        selfBox
    }

    function onMousePress(ev) {
        if($remote && extern && !extern.empty?)
            $remote.action "/presets/copy", extern
        end
    }
    label: "C"
}
