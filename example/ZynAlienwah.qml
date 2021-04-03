Group {
    id: wah
    label: "alienwah"
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
            extern: wah.extern + "Alienwah/preset"
            whenValue: lambda { wah.refresh }
        }
        Knob { extern: wah.extern + "Pvolume"}
        Knob { extern: wah.extern + "Ppanning"}

        Knob { extern: wah.extern + "Alienwah/Pfreq"   }
        Selector { extern: wah.extern + "ratiofixed" }
        Knob { extern: wah.extern + "Alienwah/Pfreqrnd"   }
        Selector     { extern: wah.extern + "Alienwah/PLFOtype" }
        Knob { extern: wah.extern + "Alienwah/PStereo" }
        Knob { extern: wah.extern + "Alienwah/Pdepth" }
        Knob { extern: wah.extern + "Alienwah/Pfeedback" }
        Knob { extern: wah.extern + "Alienwah/Pdelay" }
        Knob { extern: wah.extern + "Alienwah/Plrcross" }
        Knob { extern: wah.extern + "Alienwah/Pphase" }
    }
}
