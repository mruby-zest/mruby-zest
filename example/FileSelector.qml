Widget {
    id: file
    layer: 2

    SelColumn { layer: 2; }
    SelColumn { layer: 2; }
    TextLine { layer: 2; }
    TriggerButton {
        layer: 2;
        label: "Enter"
        whenValue: lambda {file.whenEnter}
    }
    TriggerButton {
        layer: 2;
        label: "cancel"
        whenValue: lambda {file.whenCancel}
    }

    function layout(l) {
        puts "layout of file editor"
        selfBox = self_box(l)
        ch      = chBoxes(l)
        hpad = 0.10
        l.fixed(ch[0], selfBox, 0.0+hpad, 0.05, 0.5-2*hpad, 0.60)
        l.fixed(ch[1], selfBox, 0.5+hpad, 0.05, 0.5-2*hpad, 0.60)
        l.fixed(ch[2], selfBox, 0.10,     0.70, 0.80, 0.1)
        l.fixed(ch[3], selfBox, 0.10,     0.85, 0.20, 0.1)
        l.fixed(ch[4], selfBox, 0.40,     0.85, 0.20, 0.1)
        selfBox
    }

    function draw(vg)
    {
        puts "file selector size"
        background color("000000", 125)
    }

    function whenEnter()
    {
        root.ego_death self
    }

    function whenCancel()
    {
        root.ego_death self
    }
}
