Widget {
    id: container
    x: 0
    y: 0
    w: 512
    h: 512
    Swappable {
        id: swap
        content: Qml::Knob
        x: 0
        y: 0
        w: container.w/2
        h: container.h
    }

    Button {
        x: container.w/2 
        y: 0
        w: container.w/2
        h: container.h

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

