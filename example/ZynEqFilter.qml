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
        Knob     { extern: fil.extern + "Pfreq" }
        Knob     {
            id: gain
            extern: fil.extern + "Pgain"
        }
        Knob     { extern: fil.extern + "Pq" }
        NumEntry { extern: fil.extern + "Pstages"}
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
