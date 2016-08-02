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

    //proxy method
    function refresh()
    {
        env.refresh()
    }

    function update_time()
    {
        t = 0.0;
        env.xpoints.each_with_index do |pt, idx|
            next if idx > env.points
            t += pt
        end

        ll = (t/1000).to_s[0..4] + "  sec" if(t > 1000)
        ll = (t).to_s[0..4]      + " msec" if(t < 1000)
        total_len.label = ll
        total_len.damage_self
    }

    Envelope {
        id: env
        extern: enveditor.extern
        whenTime: lambda { enveditor.update_time }
    }
    Col {
        spacer: 8
        ToggleButton   { id: free; extern: enveditor.extern + "Pfreemode"; label: "free" }
        TriggerButton  { whenValue: lambda {enveditor.add_point()}; label: "add"  }
        TriggerButton  { whenValue: lambda {enveditor.del_point()}; label: "delete" }
        Text           { label: "sustain point" }
        NumEntry       { extern: enveditor.extern + "Penvsustain"; label: "sustain" }
        Text           { id: total_len; label: "1.47 sec" }
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
