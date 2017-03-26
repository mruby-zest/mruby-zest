Widget {
    //Draw the header
    PowButton {}
    TextField {label: "text"}
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
