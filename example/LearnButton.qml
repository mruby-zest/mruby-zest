Button {
    label: "learn";
    layoutOpts: [:no_constraint]
    
    function onMousePress(ev) {
        root.learn_mode = !root.learn_mode
    }

    function animate()
    {
        if(self.value != root.learn_mode)
            self.value = root.learn_mode
            damage_self
        end
    }
}
