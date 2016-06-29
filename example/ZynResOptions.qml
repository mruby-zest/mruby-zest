ParModuleRow {
    id: resopt
    extern: "/part0/kit0/adpars/GlobalPar/Reson/"
    Button {
        extern: resopt.extern + "Penabled"
        label: "enable"
    }
    Knob { extern: resopt.extern + "PmaxdB";      label: "max"}
    Knob { extern: resopt.extern + "Pcenterfreq";  label: "c.f."}
    Knob { extern: resopt.extern + "Poctavesfreq"; label: "oct."}
    //TODO interpolate previously worked with right/left click
    //This should be broken into two separate buttons
    //Each button should have a tooltip that actually makes sense
    Button {
        whenValue: lambda {
            path = resopt.extern + "interpolatepeaks"
            $remote.action(path, 0)
        }
        label: "interp"
    }
    Button {label: "p.t. st"}
    TextBox {}
    TextBox {}
    Button {
        whenValue: lambda {
            path = resopt.extern + "zero"
            $remote.action(path)
        }
        label: "zero"
    }
    Button {
        whenValue: lambda {
            path = resopt.extern + "smooth"
            $remote.action(path)
        }
        label: "smooth"
    }
    Button {
        whenValue: lambda {
            path = resopt.extern + "randomize"
            $remote.action(path, 0)
        }
        label: "random 1"
    }
    Button {
        whenValue: lambda {
            path = resopt.extern + "randomize"
            $remote.action(path, 1)
        }
        label: "random 2"
    }
    Button {
        whenValue: lambda {
            path = resopt.extern + "randomize"
            $remote.action(path, 2)
        }
        label: "random 3"
    }
}
