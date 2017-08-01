Button {
    id: paste_button

    property Int index: nil

    onExtern: {
        paste_button.tooltip = "paste to " + paste_button.extern.to_s
    }

    function layout(l, selfBox) {
        l.aspect(selfBox, 1, 1)
        selfBox
    }

    function animate()
    {
        return if self.value == 0
        return if self.value == false
        return if self.value == true
        self.value *= 0.9
        self.value  = 0 if self.value < 0.02
        damage_self
    }

    function onMousePress(ev) {
        return if !self.active
        self.value = 1.0
        if($remote && extern && !extern.empty?)
            if(self.index)
                $remote.action("/presets/paste", extern, self.index)
            else
                $remote.action("/presets/paste", extern)
            end
        end
        damage_self
    }
    label: "P"
}
