Widget {
    id: col
    property Object valueRef: nil
    property Bool number: false
    property Bool skip:   false
    property Bool rows:   nil
    property Function whenValue: nil
    property Int  oldOff: 0

    onExtern: {
        col.valueRef = OSC::RemoteParam.new($remote, col.extern)
        col.valueRef.callback = Proc.new {|x| col.setValue(x)}
    }

    ScrollBar {
        id: scroll
        whenValue: lambda { col.tryScroll }
    }

    function onSetup(old=nil)
    {
        nrows = 24
        (nrows).times do |x|
            ch = if(number)
                Qml::NumberButton.new(db)
            else
                Qml::SelButton.new(db)
            end
            if(rows.nil? || rows.empty?)
                ch.label = Pokemon[x]
            else
                stride = 1
                stride = 2 if skip
                ch.label = if(x>=rows.length/stride)
                    ""
                else
                    rows[x*stride]
                end
                ch.tooltip = if(x*stride+1>=rows.length)
                    ""
                else
                    rows[x*stride+1]
                end

            end
            ch.layoutOpts = [:no_constraint]
            ch.whenValue  = lambda {col.cb ch}
            ch.number = x if number
            if(!number)
                ch.pad = 0
                ch.bg = Theme::BankEven if x%2 == 0
                ch.bg = Theme::BankOdd if x%2 == 1
            end
            Qml::add_child(self, ch)
        end

    }

    function tryScroll()
    {
        #24 items are visible at a time
        #center is at item 12     at value 0
        #center is at item len-12 at value 1
        stride = 1
        stride = 2 if skip
        return if rows.nil?
        n = rows.length/stride
        return if n<24
        center = (n-24)*scroll.value+12
        off    = (center-12).to_i
        if(off != self.oldOff)
            #puts "new offset #{off}"
            setValue(rows, off)
        end
    }

    function cb(ch)
    {
        children[1,99].each do |child|
            if(ch != child)
                child.value = false
            end
        end
        whenValue.call if whenValue
        damage_self
    }

    function setValue(x,offset=0)
    {
        return if(self.rows == x && offset == oldOff)
        self.oldOff = offset
        self.rows = x
        stride = 1
        stride = 2 if skip
        n = [x.length/stride, children.length-1].min
        (1..n).each do |i|
            #puts "#{i} => #{x[(i-1+offset)*stride]}"
            children[i].label = x[(i-1+offset)*stride]
            children[i].tooltip = x[(i-1+offset)*stride+1] if stride == 2
        end
        ((n+1)...children.length).each do |i|
            children[i].label = ""
        end
        damage_self
    }

    function layout(l)
    {
        selfBox = l.genBox :effvert, self
        scrlBox = children[0].layout l
        miniBox = l.genBox :virt, nil
        l.fixed(miniBox, selfBox, 0.0, 0, 0.9, 1)
        l.fixed(scrlBox, selfBox, 0.9, 0, 0.1, 1)
        Draw::Layout::vpack(l, miniBox, children[1,99].map {|x| x.layout l})
        selfBox
    }

    function selected()
    {
        children.each do |child|
            if(child.value == true)
                return child.label
            end
        end
        return ""
    }

    function selected_val()
    {
        integer = 1+oldOff if oldOff
        integer = 1
        children.each do |child|
            if(child.value == true)
                return child.tooltip
            end
            integer += 2
        end
        return ""
    }
}
