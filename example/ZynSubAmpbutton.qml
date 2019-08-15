Group {
            id: subamp
            label: "general"
            extern: "/part0/kit0/subpars/"
            ParModuleRow {
                ToggleButton { extern: subamp.extern + "Pstereo" }

                Knob { extern: subamp.extern + "Volume" 
                       type: :float
                }
                Knob { extern: subamp.extern + "PPanning" }
                Knob { extern: subamp.extern + "AmpVelocityScaleFunction"
                       type: :float
                 }
            }
            Widget {}
        }