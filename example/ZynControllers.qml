Group {
    id: ctrl
    label: "controllers"
    copyable: false
    ParModuleRow {
        Knob   { extern: ctrl.extern+"modwheel.depth"}
        Knob { extern: ctrl.extern+"filtercutoff.depth"}
        Knob { extern: ctrl.extern+"filterq.depth"}
        Knob   { extern: ctrl.extern+"bandwidth.depth"}
        //TODO fix scaling see Part.fl:489
        Knob   { extern: ctrl.extern+"pitchwheel.bendrange"}
        Knob   { extern: ctrl.extern+"panning.depth"}
    }
    ParModuleRow {
        lsize: 0.0
        Col {
            ToggleButton { extern: ctrl.extern+"modwheel.exponential"}
            ToggleButton { extern: ctrl.extern+"bandwidth.exponential"}
        }
        Col{
            ToggleButton { extern: ctrl.extern+"expression.receive"}
            ToggleButton { extern: ctrl.extern+"volume.receive"}
        }
        Col {
            ToggleButton { extern: ctrl.extern+"fmamp.receive"}
            ToggleButton { extern: ctrl.extern+"sustain.receive"}
        }
    }
}
