Widget {
    id: container

    function layout(l)
    {
        selfBox = l.genBox :testRoot, self
        swapBox = swap.layout(l)
        buttBox = but.layout(l)

        l.fixed(swapBox, selfBox, 0,0,0.5,1)
        l.fixed(buttBox, selfBox, 0.5,0,0.5,1)
        selfBox
    }
    Swappable {
        id: swap
        content: Qml::Knob
    }

    Button {
        id: but

        layoutOpts: [:no_constraint]

        onValue: {
            puts "value changed..."
            if(swap.content == Qml::Knob)
                swap.content = Qml::DropDown
            else
                swap.content = Qml::Knob
            end
        }

        label: "swap"
    }
}

