Widget {
    id: padprofile
    property Function whenValue: nil
    function cb()
    {
        whenValue.call if whenValue
    }
    Widget {
        function onSetup() {
            cb_ = lambda {padprofile.cb}
            children.each do |x|
                x.layoutOpts = [:no_constraint]
                x.whenValue  = cb_ if x.respond_to? :whenValue
            end
        }


        //row 1
        TextBox { label: "base type"}
        HSlider { extern: padprofile.extern + "Php.modulator.par1"}
        //row 2
        Selector {extern: padprofile.extern + "Php.base.type"}
        HSlider { extern: padprofile.extern + "Php.modulator.freq"}
        //row 3
        Selector {extern: padprofile.extern + "Php.onehalf"}
        HSlider { extern: padprofile.extern + "Php.width"}
        //row 4
        ToggleButton {
            label: "autoscale"
            extern: padprofile.extern + "Php.autoscale"
        }
        HSlider { extern: padprofile.extern + "Php.base.par1"}
        //row 5
        TextBox { label: "amp. mlt."}
        HSlider { extern: padprofile.extern + "Php.freqmult"}
        //row 6
        Selector {extern: padprofile.extern + "Php.amp.type"}
        Widget {}
        //row 7
        TextBox { bg: nil; label: "amp. mode"}
        HSlider { extern: padprofile.extern + "Php.amp.par1"}
        //row 8
        Selector {extern: padprofile.extern + "Php.amp.mode"}
        HSlider { extern: padprofile.extern + "Php.amp.par2"}

        function class_name() { "overtone" }
        function layout(l, selfBox) {
            Draw::Layout::grid(l, selfBox, children, 8, 2, 1, 2)
        }
    }
    function layout(l, selfBox)
    {
        pad = 4
        children[0].fixed_long(l, selfBox, 0, 0, 1, 1,
            pad, pad, -2*pad, -2*pad)
        selfBox
    }

}
