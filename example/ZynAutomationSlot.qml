Widget {

    function setActive()
    {
        active_indicator.active = true
    }

    //Draw the header
    PowButton {}
    TextField {
        label: "slot"
        function onKey(k, mode)
        {
        }
    }
    ArrowBox {
        id: active_indicator
    }
    function onSetup(old=nil)
    {
        #//Fetch parameters

        #//Reallocate total number of child elements if 
    }

    function layout(l, selfBox)
    {
        Draw::Layout::hfill(l, selfBox, children, [0.15, 0.7, 0.15])
    }
}
