Widget {
    id: automation_view
    property Object valueRef: nil

    //Automation Slots
    Widget {
        id: slots
        function onSetup(old=nil)
        {
            return if children.length > 5
            #//Fetch all parameters
            16.times do |i|
                slot = Qml::ZynAutomationSlot.new(db)
                slot.slot_id = i
                Qml::add_child(self,slot)
                slot.set_active if(i==root.get_view_pos(:slot))
            end
        }
        function layout(l, selfBox) {
            Draw::Layout::vpack(l, selfBox, children)
        }
        function draw(vg)
        {
        }
    }

    //Detailed View
    Widget {
        TabGroup {
            id: tgrp
            Button {
                label: "normal learn"
                tooltip: "learn parameters to unused slot"
                whenValue: lambda { automation_view.set_mode(:normal) }
            }
            Button {
                label: "macro learn"
                tooltip: "learn parameters to the active slot"
                whenValue: lambda { automation_view.set_mode(:macro) }
            }
        }
        ZynAutomationMidiChan {
            id: chan
            label: "MIDI Chan 0 CC 12 - Relearning"
        }
        Widget {
            id: details
            function onSetup(old=nil)
            {
                return if children.length > 2
                #//Fetch all parameters
                4.times do |i|
                    slot = Qml::ZynAutomationParam.new(db)
                    Qml::add_child(self,slot)
                    slot.active = false if i!=0
                end
            }
            function layout(l, selfBox) {
                Draw::Layout::grid(l, selfBox, children, 2, 2, 5, 5)
            }
        }
        function layout(l, selfBox) {
            Draw::Layout::vfill(l, selfBox, children, [0.05,0.05,0.9])
        }
    }

    function layout(l, selfBox) {
        Draw::Layout::hfill(l, selfBox, children, [0.3,0.7])
    }

    function set_view() {
        slot        = root.get_view_pos(:slot)
        slot_path   = "/automate/slot#{slot}/"

        chan.extern = slot_path
        (0..3).each do |i|
            details.children[i].extern = slot_path + "param#{i}/"
        end
        (0...slots.children.length).each do |i|
            slots.children[i].set_active(slot == i)
            slots.children[i].extern = "/automate/slot#{i}/"
        end
    }

    function set_active(slot_id) {
        if(root.get_view_pos(:slot) != slot_id)
            root.set_view_pos(:slot, slot_id)
            root.change_view
        end
    }

    function set_mode(mode) {
        $remote.automation.mode = mode
        if($remote.automation.mode == :normal)
            tgrp.children[0].value = true
            tgrp.children[1].value = false
        else
            tgrp.children[0].value = false
            tgrp.children[1].value = true
        end
        tgrp.damage_self
    }

    function onSetup(old=nil) {
        details.onSetup

        self.valueRef = OSC::RemoteParam.new($remote, "/automate/active-slot")
        self.valueRef.type = "i"
        self.valueRef.mode = :normal_int
        self.valueRef.callback = lambda {|x| set_active(x)}

        if($remote.automation.mode == :normal)
            tgrp.children[0].value = true
            tgrp.children[1].value = false
        else
            tgrp.children[0].value = false
            tgrp.children[1].value = true
        end

        set_view
    }


}
