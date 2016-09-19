Group {
    id: chorus
    label: "chorus"
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
            extern: chorus.extern + "Chorus/preset"
            whenValue: lambda { chorus.refresh }
        }
        Knob { extern: chorus.extern + "Pvolume"}
        Knob { extern: chorus.extern + "Ppanning"}

        Knob { extern: chorus.extern + "Chorus/Pfreq" }
        Knob { extern: chorus.extern + "Chorus/Pfreqrnd" }
        Selector { extern: chorus.extern + "Chorus/PLFOtype" }
        Knob { extern: chorus.extern + "Chorus/PStereo" }
        Knob { extern: chorus.extern + "Chorus/Pdepth" }
        Knob { extern: chorus.extern + "Chorus/Pdelay" }
        Knob { extern: chorus.extern + "Chorus/Pfeedback" }
        Knob { extern: chorus.extern + "Chorus/Plrcross" }
        ToggleButton { extern: chorus.extern + "Chorus/Pflangemode" }
        ToggleButton { extern: chorus.extern + "Chorus/Poutsub" }
    }
}

