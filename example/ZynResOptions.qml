ParModuleRow {
    id: resopt
    property Function whenValue: nil
    function cb()
    {
        whenValue.call if whenValue
    }
    ToggleButton {
        extern: resopt.extern + "Penabled"
        label: "enable"
    }
    Knob { extern: resopt.extern + "PmaxdB";      label: "max"}
    Knob { extern: resopt.extern + "Pcenterfreq";  label: "c.f."}
    Knob { extern: resopt.extern + "Poctavesfreq"; label: "oct."}
    //TODO interpolate previously worked with right/left click
    //This should be broken into two separate buttons
    //Each button should have a tooltip that actually makes sense
    TriggerButton {
        whenValue: lambda {
            path = resopt.extern + "interpolatepeaks"
            $remote.action(path, 0)
            resopt.cb
        }
        label: "interp"
        tooltip: "Interpolate between sparsely added points"
    }
    ToggleButton {
        extern: resopt.extern + "Pprotectthefundamental"
    }
    TextBox {}
    TextBox {}
    TriggerButton {
        whenValue: lambda {
            path = resopt.extern + "zero"
            $remote.action(path)
            resopt.cb
        }
        label: "zero"
        tooltip: "reset frequency response"
    }
    TriggerButton {
        whenValue: lambda {
            path = resopt.extern + "smooth"
            $remote.action(path)
            resopt.cb
        }
        label: "smooth"
        tooltip: "smooth out frequency response"
    }
    TriggerButton {
        whenValue: lambda {
            path = resopt.extern + "randomize"
            $remote.action(path, 0)
            resopt.cb
        }
        label: "random 1"
        tooltip: "create slow changing random response"
    }
    TriggerButton {
        whenValue: lambda {
            path = resopt.extern + "randomize"
            $remote.action(path, 1)
            resopt.cb
        }
        label: "random 2"
        tooltip: "create random response"
    }
    TriggerButton {
        whenValue: lambda {
            path = resopt.extern + "randomize"
            $remote.action(path, 2)
            resopt.cb
        }
        label: "random 3"
        tooltip: "create fast changing random response"
    }
}
