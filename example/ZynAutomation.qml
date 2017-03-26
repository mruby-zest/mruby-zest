Widget {

    //Automation Slots
    Widget {
        function onSetup(old=nil)
        {
            return if children.length > 5
            #//Fetch all parameters
            10.times do 
                slot = Qml::ZynAutomationSlot.new(db)
                Qml::add_child(self,slot)
            end
        }
        function layout(l, selfBox) {
            Draw::Layout::vpack(l, selfBox, children)
        }
        function draw(vg)
        {
            background(color(:red))
        }
    }

    //Detailed View
    Widget {
        function onSetup(old=nil)
        {
            return if children.length > 2
            #//Fetch all parameters
            4.times do 
                slot = Qml::ZynAutomationParam.new(db)
                Qml::add_child(self,slot)
            end
        }
        function layout(l, selfBox) {
            Draw::Layout::grid(l, selfBox, children, 2, 2, 5, 5)
        }
    }

    function layout(l, selfBox) {
        Draw::Layout::hfill(l, selfBox, children, [0.3,0.7])
    }
    

}
