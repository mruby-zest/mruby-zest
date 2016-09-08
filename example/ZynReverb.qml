Group {
    id: reverb
    label: "reverb"
    topSize: 0.2

    function refresh() {
        return if rw.content.nil?
        return if rw.content.children.length < 4
        rw.content.children[3..-1].each do |c|
            c.refresh
        end
    }

    ParModuleRow {
        id: rw
        layoutOpts: []
        Selector {
            extern: reverb.extern + "Reverb/preset"
            whenValue: lambda { reverb.refresh }
        }
        Knob { extern: reverb.extern + "Pvolume"}
        Knob { extern: reverb.extern + "Ppanning"}

        Selector { extern: reverb.extern + "Reverb/Ptype"}
        Knob { extern: reverb.extern + "Reverb/Proomsize" }
        Knob { extern: reverb.extern + "Reverb/Ptime" }
        Knob { extern: reverb.extern + "Reverb/Pidelay"}
        Knob { extern: reverb.extern + "Reverb/Pidelayfb"}
        Knob { extern: reverb.extern + "Reverb/Plpf"}
        Knob { extern: reverb.extern + "Reverb/Phpf"}
        Knob { extern: reverb.extern + "Reverb/Plohidamp"}
        Knob { extern: reverb.extern + "Reverb/Pbandwidth" }
    }
}
