TriggerButton {
    id: filebutton
    property String extval: ".scl";
    whenValue: lambda { filebutton.file_select() }

    function onMousePress(ev) {
        return if !self.active
        self.value = 1.0
        whenValue.call if whenValue
        damage_self
    }

    function setup_widget(w)
    {
        w.onSetup()
        w.children.each do |c|
            setup_widget(c)
        end
    }

    function file_select()
    {
        win = window()
        wid = Qml::FileSelector.new(db)
        wid.whenValue = lambda { |x| filebutton.file_value(x)}
        wid.x = 0#-global_x
        wid.y = 0#-global_y
        wid.w = win.w
        wid.h = win.h
        wid.ext = self.extval
        Qml::add_child(win, wid)
        self.db.update_values
        setup_widget wid
        self.db.update_values

        if(root)
            root.smash_layout
            root.damage_item(win, :all)
        end
    }

    function file_value(val)
    {
        return if val == :cancel
        $remote.action(self.extern, val)
    }
}
