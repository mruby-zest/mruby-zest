Widget {
    id: voice_item
    property Array weights: [0.05, 0.05, 0.2, 0.2, 0.3, 0.2]
    property Function whenValue: nil

    function unlearn() {
        return if ctrl.label.empty?
        $remote.action("/unlearn", ctrl.label)
        whenValue.call if whenValue
    }

    //voice ID
    TriggerButton {
        tooltip: "unlearn midi control"
        label: voice_item.label;
        layoutOpts: [:no_constraint]
        whenValue: lambda { voice_item.unlearn }
    }
    //channel
    TextBox { bg: Theme::GeneralBackground;}
    //control
    TextBox { bg: Theme::GeneralBackground;}
    //address
    TextBox { id: ctrl; bg: Theme::GeneralBackground;  pad: 0; align: :left;}
    //min
    TextBox { bg: Theme::GeneralBackground; }
    //max
    TextBox { bg: Theme::GeneralBackground; }

    function layout(l)
    {
        selfBox = l.genBox :zavlr, self
        chBox   = []

        off = 0.0
        hpad = 1/128
        children.each_with_index do |ch, ind|
            weight = weights[ind]
            box    = ch.layout(l)
            l.fixed(box, selfBox, off+hpad, 0.0, weight-2*hpad, 1.0)
            off += weight
        end
        selfBox
    }
}
