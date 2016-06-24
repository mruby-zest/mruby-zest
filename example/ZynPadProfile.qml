Widget {
    id: padprofile
    Widget {
        function onSetup() {
            children.each do |x|
                x.layoutOpts = [:no_constraint]
            end
        }
    
    
        //row 1
        TextBox { bg: nil; label: "base type"}
        HSlider { label: "str"}
        //row 2
        Selector {extern: padprofile.extern + "Php.base.type"}
        HSlider { label: "sfreq"}
        //row 3
        Selector {extern: padprofile.extern + "Php.onehalf"}
        HSlider { label: "size"}
        //row 4
        Button  { label: "autoscale"}
        HSlider { label: "width"}
        //row 5
        TextBox { bg: nil; label: "amp. mlt."}
        HSlider { label: "freq.mlt"}
        //row 6
        Selector {extern: padprofile.extern + "Php.amp.type"}
        Widget {}
        //row 7
        TextBox { bg: nil; label: "amp. mode"}
        HSlider { label: "par1"}
        //row 8
        Selector {extern: padprofile.extern + "Php.amp.mode"}
        HSlider { label: "par2"}
        function layout(l)
        {
            selfBox = l.genBox :overtone, self
            chBox   = children.map {|x| x.layout l}
            Draw::Layout::grid(l, selfBox, chBox, 8, 2, 1, 2)
        }
    }
    function layout(l)
    {
        selfBox = l.genBox :overtone, self
        chBox   = children[0].layout l
        pad = 4
        l.fixed_long(chBox, selfBox, 0, 0, 1, 1, 
            pad, pad, -2*pad, -2*pad)
        selfBox
    }

}
