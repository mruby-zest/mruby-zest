Group {
    id: ctrl
    label: "controllers"
    copyable: false
    ParModuleRow {
        Button { extern: ctrl.extern+"modwheel.exponential"}
        Knob   { extern: ctrl.extern+"modwheel.depth"}
        Button { extern: ctrl.extern+"bandwidth.exponential"}
        Knob   { extern: ctrl.extern+"bandwidth.depth"}
        //TODO fix scaling see Part.fl:489
        Knob   { extern: ctrl.extern+"pitchwheel.bendrange"}
        Knob   { extern: ctrl.extern+"panning.depth"}
    }
    ParModuleRow {
        //TODO
        Knob { extern: ctrl.extern+"filtercutoff.depth"}
        Knob { extern: ctrl.extern+"filterq.depth"}
        Button { extern: ctrl.extern+"expression.receive"}
        Button { extern: ctrl.extern+"volume.receive"}
        Button { extern: ctrl.extern+"fmamp.receive"}
        Button { extern: ctrl.extern+"sustain.receive"}
    }
}
