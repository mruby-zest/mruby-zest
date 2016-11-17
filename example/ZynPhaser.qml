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
        rw2.content.children.each do |c|
            c.refresh
        end
    }

    function changeAnalog(value) {
        knobWidth.active = value
        knobPhase.active = !value
        knobOffset.active = value
        knobLRcross.active = !value
        knobWidth.damage_self
        knobPhase.damage_self
        knobOffset.damage_self
        knobLRcross.damage_self
        refresh()
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
        Knob { extern: phaser.extern + "Phaser/lfo.Pstereo" }
        Knob { extern: phaser.extern + "Phaser/Pdepth" }
        Knob { extern: phaser.extern + "Phaser/Pfb" }
    }

    ParModuleRow {
        id: rw2
        layoutOpts: []
        NumEntry { extern: phaser.extern + "Phaser/Pstages" }
        Knob { id: knobLRcross
            extern: phaser.extern + "Phaser/Plrcross" }
        Knob { id: knobOffset
            extern: phaser.extern + "Phaser/Poffset" }
        ToggleButton { extern: phaser.extern + "Phaser/Poutsub" }
        Knob { id: knobPhase
            extern: phaser.extern + "Phaser/Pphase" }
        Knob { id: knobWidth
            extern: phaser.extern + "Phaser/Pwidth" }
        ToggleButton { extern: phaser.extern + "Phaser/Phyper" }
        Knob { extern: phaser.extern + "Phaser/Pdistortion" }
        ToggleButton {
            id: analogButton
            extern: phaser.extern + "Phaser/Panalog"
            whenValue: lambda() { phaser.changeAnalog(analogButton.value) }
        }
    }
}
