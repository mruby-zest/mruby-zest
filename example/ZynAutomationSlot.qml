Widget {
    //Draw the header
    PowButton {}
    TextField {
        label: "slot"
        function onKey(k, mode)
        {
        }
    }
    function onSetup(old=nil)
    {
        #//Fetch parameters

        #//Reallocate total number of child elements if 
    }

    function layout(l, selfBox)
    {
        Draw::Layout::hpack(l, selfBox, children)
    }
}
