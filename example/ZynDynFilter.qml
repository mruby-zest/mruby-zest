Widget {
    id: dyn
    VisFilter {
        extern: dyn.extern + "filterpars/"
    }
    ZynAnalogFilter {
        extern: dyn.extern + "filterpars/"
    }
    ParModuleRow {
        Knob {         extern: dyn.extern + "DynamicFilter/Pfreq" }
        Knob {         extern: dyn.extern + "DynamicFilter/Pfreqrnd" }
        Selector {     extern: dyn.extern + "DynamicFilter/PLFOtype" }
        ToggleButton { extern: dyn.extern + "DynamicFilter/PStereo" }
        Knob {         extern: dyn.extern + "DynamicFilter/Pdepth" }
        Knob {         extern: dyn.extern + "DynamicFilter/Pampsns" }
        ToggleButton { extern: dyn.extern + "DynamicFilter/Pampsnsinv" }
        Knob {         extern: dyn.extern + "DynamicFilter/Pampsmooth" }
    }
    function draw(vg) {
        Draw::GradBox(vg, Rect.new(0, 0, w, h))
    }

    function layout(l) {
        Draw::Layout::vpack(l, self_box(l), chBoxes(l))
    }

    function onSetup(old=nil)
    {
    }

}
