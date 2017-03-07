Button {
    id: paste_button

    onExtern: {
        paste_button.tooltip = "paste to " + paste_button.extern.to_s
    }

    function layout(l, selfBox) {
        l.aspect(selfBox, 1, 1)
        selfBox
    }
    function onMousePress(ev) {
        if($remote && extern && !extern.empty?)
            $remote.action "/presets/paste", extern
        end
    }
    label: "P"
}
