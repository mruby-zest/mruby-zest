Widget {
    id: enveditor

    function add_point()
    {
        return if self.extern.empty?
        return if env.selected == nil
        return if !free.value
        puts "try to add point"
        path = self.extern + "addPoint"
        $remote.action(path, env.selected)
        env.refresh
    }
    function del_point()
    {
        return if self.extern.empty?
        return if env.selected == nil
        return if !free.value
        puts "try to delete point"
        path = self.extern + "delPoint"
        $remote.action(path, env.selected)
        env.refresh
    }
    function sus_point()
    {
        puts "try to set sustain point"
    }
    Envelope {
        id: env
        extern: enveditor.extern
    }
    Col {
        spacer: 8
        ToggleButton   { id: free; extern: enveditor.extern + "Pfreemode"; label: "free" }
        Button         { whenValue: lambda {enveditor.add_point()}; label: "add"  }
        Button         { whenValue: lambda {enveditor.del_point()}; label: "delete" }
        Text           { label: "sustain point" }
        NumEntry       { whenValue: lambda {enveditor.sus_point()}; label: "sustain" }
        Text           { label: "1.47 sec" }
    }

    function layout(l) {
        Draw::Layout::hfill(l, self_box(l), chBoxes(l), [0.85, 0.15], 0, 3)
    }

    //Activate Envelope
    function onSetup(old=nil)
    {
        env.extern()
    }
}
