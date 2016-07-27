Group {
    id: phaser
    label: "phaser"
    topSize: 0.2

    ParModuleRow {
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
