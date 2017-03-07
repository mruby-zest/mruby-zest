Widget {
    id: dyn

    property Object valueRef: nil
    property Symbol filtertype: nil
    
    onExtern: {
        dyn.add_cat()
    }

    function add_cat()
    {
        return if self.valueRef
        if(self.valueRef.nil?)
            path = self.extern + "filterpars/Pcategory"
            self.valueRef = OSC::RemoteParam.new($remote, path)
            self.valueRef.mode = :full
            self.valueRef.callback = lambda {|x|
                dyn.filtertype = [:analog, :formant, :statevar][x]
                swapp.content  = Qml::ZynDAFilter if dyn.filtertype != :formant
                swapp.content  = Qml::ZynDFFilter if dyn.filtertype == :formant
            }
        end
    }

    Swappable {
        id: swapp
        extern: dyn.extern
        content: Qml::ZynDAFilter
    }
    ParModuleRow {
        Knob { extern: dyn.extern + "Pvolume"}
        Knob { extern: dyn.extern + "Ppanning"}

        Knob {         extern: dyn.extern + "DynamicFilter/Pfreq" }
        Knob {         extern: dyn.extern + "DynamicFilter/Pfreqrnd" }
        Selector {     extern: dyn.extern + "DynamicFilter/PLFOtype" }
        Knob {         extern: dyn.extern + "DynamicFilter/PStereo" }
        Knob {         extern: dyn.extern + "DynamicFilter/Pdepth" }
        Knob {         extern: dyn.extern + "DynamicFilter/Pampsns" }
        ToggleButton { extern: dyn.extern + "DynamicFilter/Pampsnsinv" }
        Knob {         extern: dyn.extern + "DynamicFilter/Pampsmooth" }
        Selector {
            id: cat
            //whenValue: lambda { box.change_cat};
            extern: dyn.extern + "filterpars/Pcategory"
        }
    }
    function draw(vg) {
        Draw::GradBox(vg, Rect.new(0, 0, w, h))
    }

    function layout(l, selfBox) {
        Draw::Layout::vfill(l, selfBox, children, [0.75,0.25])
    }

    function onSetup(old=nil)
    {}
}
