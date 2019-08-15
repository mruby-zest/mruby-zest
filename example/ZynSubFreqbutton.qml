 Group {
            id: subfqbutton
            extern: "/part0/kit0/subpars/"
            label: "general"
            ParModuleRow {
                Knob {     extern: subfqbutton.extern + "PDetune" }
                Selector { extern: subfqbutton.extern + "PDetuneType" }
                NumEntry { extern: subfqbutton.extern + "octave" }
                Knob     { extern: subfqbutton.extern + "PBendAdjust"}
                //eqt

            }
            ParModuleRow {
                ToggleButton {   extern: subfqbutton.extern + "Pfixedfreq" }
                Knob   {   extern: subfqbutton.extern + "PfixedfreqET" }
                Knob     { extern: subfqbutton.extern + "POffsetHz"}
            }
        }