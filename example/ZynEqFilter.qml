Widget {
    id: fil
    property Function whenValue: nil
    ParModuleRow {
        Selector {
            id: selector
            extern: fil.extern + "Ptype"
            whenValue: lambda() {
                fil.gain.active = (selector.selected >= 7)
                fil.gain.damage_self
                fil.gain.refresh()
                fil.cb # parent callback
            }
        }
        Knob {
            extern: fil.extern + "Pfreq"
            whenValue: lambda { fil.cb }
        }
        Knob     {
            id: gain
            extern: fil.extern + "Pgain"
            whenValue: lambda { fil.cb }
        }
        Knob     {
            extern: fil.extern + "Pq"
            whenValue: lambda { fil.cb }
        }
        NumEntry {
            extern: fil.extern + "Pstages"
            whenValue: lambda { fil.cb }
        }
    }
    function cb() {
        whenValue.call if whenValue
    }
    function onSetup(old=nil) {
        children[0].children.each do |ch|
            ch.whenValue = lambda {fil.cb} if(ch.respond_to?(:whenValue) && ch.whenValue.nil?)
        end
    }
}
