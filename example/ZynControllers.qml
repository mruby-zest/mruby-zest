Group {
    id: ctrl
    label: "controllers"
    copyable: false
    ParModuleRow {
        ToggleButton { extern: ctrl.extern+"modwheel.exponential"}
        Knob   { extern: ctrl.extern+"modwheel.depth"}
        ToggleButton { extern: ctrl.extern+"bandwidth.exponential"}
        Knob   { extern: ctrl.extern+"bandwidth.depth"}
        //TODO fix scaling see Part.fl:489
        Knob   { extern: ctrl.extern+"pitchwheel.bendrange"}
        Knob   { extern: ctrl.extern+"panning.depth"}
    }
    ParModuleRow {
        //TODO
        Knob { extern: ctrl.extern+"filtercutoff.depth"}
        Knob { extern: ctrl.extern+"filterq.depth"}
        ToggleButton { extern: ctrl.extern+"expression.receive"}
        ToggleButton { extern: ctrl.extern+"volume.receive"}
        ToggleButton { extern: ctrl.extern+"fmamp.receive"}
        ToggleButton { extern: ctrl.extern+"sustain.receive"}
    }
}
