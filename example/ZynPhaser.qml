Group {
    id: phaser
    label: "phaser"
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
            extern: phaser.extern + "Phaser/preset"
            whenValue: lambda { phaser.refresh }
        }

        Knob { extern: phaser.extern + "Pvolume"}
        Knob { extern: phaser.extern + "Ppanning"}

        Knob { extern: phaser.extern + "Phaser/lfo.Pfreq" }
        Knob { extern: phaser.extern + "Phaser/lfo.Prandomness" }
        Selector { extern: phaser.extern + "Phaser/lfo.PLFOtype" }
        ToggleButton { extern: phaser.extern + "Phaser/lfo.Pstereo" }
        Knob { extern: phaser.extern + "Phaser/Pdepth" }
        Knob { extern: phaser.extern + "Phaser/Pfb" }
        NumEntry { extern: phaser.extern + "Phaser/Pstages" }
        Knob { extern: phaser.extern + "Phaser/Plrcross" }
        Knob { extern: phaser.extern + "Phaser/Poffset" }
        ToggleButton { extern: phaser.extern + "Phaser/Poutsub" }
        Knob { extern: phaser.extern + "Phaser/Pphase" }
        Knob { extern: phaser.extern + "Phaser/Pwidth" }
        ToggleButton { extern: phaser.extern + "Phaser/Phyper" }
        Knob { extern: phaser.extern + "Phaser/Pdistortion" }
        ToggleButton { extern: phaser.extern + "Phaser/Panalog" }
    }
}
