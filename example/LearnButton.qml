Button {
    label: "learn";
    layoutOpts: [:no_constraint]

    function animate()
    {
        if(self.value != root.learn_mode)
            self.value = root.learn_mode
            damage_self
        end
    }
}
