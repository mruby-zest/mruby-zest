Widget {
    id: col
    property Object valueRef: nil
    property Bool number: false
    property Bool skip:   false
    property Bool rows:   nil
    property Function whenValue: nil

    onExtern: {
        col.valueRef = OSC::RemoteParam.new($remote, col.extern)
        col.valueRef.callback = Proc.new {|x| col.setValue(x)}
    }

    ScrollBar {
        orientation: :vertical
    }

    function onSetup(old=nil)
    {
        nrows = 24
        (nrows).times do |x|
            ch = if(number)
                Qml::NumberButton.new(db)
            else
                Qml::Button.new(db)
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
            end
            ch.layoutOpts = [:no_constraint]
            ch.whenValue  = lambda {col.cb ch}
            ch.number = x if number
            Qml::add_child(self, ch)
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

    function setValue(x)
    {
        self.rows = x
        stride = 1
        stride = 2 if skip
        n = [x.length/stride, children.length].min
        (1...n).each do |i|
            children[i].label = x[(i-1)*stride]
        end
        (n...children.length).each do |i|
            children[i].label = ""
        end
        damage_self
    }

    function draw(vg)
    {
        pad  = 1/128.0
        pad2 = (1-2*pad)
        vg.path do |v|
            v.rect(pad*w,pad*h,pad2*w,pad2*h)
            v.fill_color color("123456")
            v.fill
        end
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
        integer = 1
        children.each do |child|
            if(child.value == true)
                return rows[integer] if integer < rows.length
            end
            integer += 2
        end
        return ""
    }
}
