Button {
    function onMousePress(ev) {
        self.value = 1.0
        whenValue.call if whenValue
        damage_self
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
}
