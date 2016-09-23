Widget {
    id: fil
    property Function whenValue: nil
    ParModuleRow {
        Selector { extern: fil.extern + "Ptype" }
        Knob     { extern: fil.extern + "Pfreq" }
        Knob     { extern: fil.extern + "Pgain" }
        Knob     { extern: fil.extern + "Pq" }
        NumEntry { extern: fil.extern + "Pstages"}
    }
    function cb() {
        whenValue.call if whenValue
    }
    function onSetup(old=nil) {
        children[0].children.each do |ch|
            ch.whenValue = lambda {fil.cb} if ch.respond_to? :whenValue
        end
    }
}
