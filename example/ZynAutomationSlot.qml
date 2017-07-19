Widget {
    id: slot

    property Int slot_id: 0

    function set_active(active=true)
    {
        active_indicator.active = active
    }

    //Draw the header
    //PowButton {
    //    id: pow
    //}
    ClearBox {
        id: clr
        tooltip: "clear automation slot"
        whenValue: lambda {$remote.action(slot.extern + "clear")}
    }
    Widget {
        TextField {
            id: name
            label: "slot"
        }
        HSlider {
            id: slide
            type: "f"
            value: 0.1
        }
        function layout(l, selfBox) {
            Draw::Layout::vfill(l, selfBox, children, [0.90, 0.10])
        }
    }
    ArrowBox {
        id: active_indicator
        whenValue: lambda {
            $remote.action("/automate/active-slot", slot.slot_id)
            root.set_view_pos(:slot, slot.slot_id)
            root.change_view
        }
    }
    function onSetup(old=nil)
    {
        #//Fetch parameters

        #//Reallocate total number of child elements if
    }

    onExtern: {
        #pow.extern   = slot.extern + "active"
        name.extern  = slot.extern + "name"
        slide.extern = slot.extern + "value"
    }

    function layout(l, selfBox)
    {
        Draw::Layout::hfill(l, selfBox, children, [0.10, 0.8, 0.10])
    }

    function animate()
    {
        cur_time   = Time.new
        @atime   ||= cur_time
        old_time   = @atime
        if((cur_time-old_time) >= 1/30.0)
            @atime = cur_time
            slide.refresh
        end
    }
}
