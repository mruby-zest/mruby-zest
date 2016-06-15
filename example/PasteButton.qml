Button {
    function layout(l)
    {
        selfBox = l.genBox :copyButton, button_p
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
