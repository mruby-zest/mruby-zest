Widget {
    id: sequencer

    function clear()
    {
        (0...128).each do |i|
            $remote.setf(sequencer.extern + "sequence" + i.to_s, 0.0)
        end
    }

    SEQEdit {
        extern: sequencer.extern
        id: seqedit
    }

    ScrollBar {
        id: scroll
        vertical: false
        value: 0
        whenValue: lambda {seqedit.set_scroll scroll.value}
    }
    
    ParModuleRow {
        id: controls
        TriggerButton   {
            whenValue: lambda {sequencer.clear}
            label: "reset"
            tooltip: "reset all steps"
        }
        Knob {extern: sequencer.extern+"steps"}
    }

    function layout(l, selfBox)
    {
        seqedit.fixed(l,    selfBox, 0.00, 0.00, 1.00, 0.80)
        scroll.fixed(l,     selfBox, 0.00, 0.81, 1.00, 0.05)
        controls.fixed(l,   selfBox, 0.00, 0.87, 1.00, 0.13)
        selfBox
    }

}
