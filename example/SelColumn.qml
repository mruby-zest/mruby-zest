Widget {
    id: col
    property Object valueRef: nil
    property Bool number: false
    property Bool skip:   false
    property Bool rows:   nil
    property Int  nrows:  24
    property Function whenValue: nil
    property Int  oldOff: 0
    property Object value_sel: nil
    property Object value_lab: nil
    property Bool   clear_on_extern: nil
    property Bool   doupcase: true
    property String pattern: nil
    property Symbol style: :normal

    onExtern: {
        col.valueRef = OSC::RemoteParam.new($remote, col.extern)
        col.valueRef.callback = Proc.new {|x|
            x = [x] if x.class != Array
            col.clear_sel if col.clear_on_extern
            col.setValue(col.filter(x)) if !col.skip
            col.setValue(x)             if  col.skip
            # Resets the scroll bar to the top.
            scroll.value = 1.0
        }
    }

    ScrollBar {
        id: scroll
        style: col.style
        whenValue: lambda { col.tryScroll }
    }

    function clear()
    {
        clear_sel
        children.each do |c|
            c.value = false if c.class != Qml::ScrollBar
            c.damage_self
        end
    }

    function clear_sel()
    {
        self.value_sel = nil
        self.value_lab = nil
    }

    function onScroll(ev)
    {
        return if !scroll.active
        num_visible_rows = self.rows.length.to_f / getStride()
        scroll.updatePos(ev.dy.to_f/(self.nrows-num_visible_rows))
    }

    function draw(vg)
    {
        if(self.style == :overlay)
            draw_overlay(vg)
        else
            draw_normal(vg)
        end

    }

    function draw_overlay(vg)
    {
        vg.path do
            vg.rect(0, 0, w, h)
            vg.stroke_color  color("56c0a5")
            vg.stroke_width 1.0
            vg.stroke
        end
        titleH = self.h*1.0/(children.length + 1)
        vg.fill_color Theme::TextModColor
        vg.text_align NVG::ALIGN_CENTER | NVG::ALIGN_MIDDLE
        vg.font_size titleH*0.9
        vg.text(0.9*w/2,titleH/2,label.upcase)
    }

    function draw_normal(vg)
    {
        titleH = self.h*1.0/(children.length + 1)
        vg.path do
            vg.rect(0, 0, 0.9*w, titleH)
            vg.fill_color Theme::BankOdd
            vg.fill
        end
        vg.fill_color Theme::TextModColor
        vg.text_align NVG::ALIGN_CENTER | NVG::ALIGN_MIDDLE
        vg.font_size titleH*0.9
        vg.text(0.9*w/2,titleH/2,label.upcase)
    }

    function getStride()
    {
        stride = 1
        stride = 2 if skip
        stride
    }

    function onSetup(old=nil)
    {
        return if children.length > 10
        scroll.layer = self.layer
        (self.nrows).times do |x|
            ch = if(number)
                Qml::NumberButton.new(db)
            else
                Qml::SelButton.new(db)
            end
            if(rows.nil? || rows.empty?)
                ch.label = ""
            else
                stride = getStride()
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

            ch.layer      = col.layer
            ch.number = x if number
            ch.style    = self.style    if ch.respond_to? :style
            ch.doupcase = self.doupcase if ch.respond_to? :doupcase
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
        return if rows.nil?

        stride = getStride()
        n = rows.length/stride
        return if n<nrows

        offset = (1.0-scroll.value)*(n-nrows) + 0.5
        offset = offset.to_i

        if(offset != self.oldOff)
            setValue(rows, offset)
        end
    }

    function cb(ch)
    {
        if(ch.value)
            self.value_sel = ch.tooltip
            self.value_lab = ch.label
        else
            self.value_sel = nil
            self.value_lab = nil
        end

        children[1,99].each do |child|
            if(ch != child)
                child.value = false
            end
        end
        whenValue.call if whenValue
        damage_self
    }

    function filter(x)
    {
        y = []
        x.each do |x|
            next if(x != "." && x != ".." && x[0] == ".")
            next if(x[-1] == "~")
            next if self.pattern && !self.pattern.match(x)
            y << x
        end
        y
    }

    function setValue(x,offset=0)
    {
        return if(self.rows == x && offset == oldOff)
        self.oldOff = offset
        self.rows = x
        stride = getStride()
        nn = x.length/stride
        nsize = [0.05, [1.0, self.nrows*1.0/nn].min].max
        if(nsize != scroll.bar_size)
            scroll.bar_size = nsize
            scroll.damage_self
        end
        n = [x.length/stride, children.length-1].min
        (1..n).each do |i|
            nv = (children[i].label == self.value_lab &&
                  children[i].tooltip == self.value_sel)
            children[i].label   = x[(i-1+offset)*stride]
            children[i].tooltip = x[(i-1+offset)*stride+1] if stride == 2
            children[i].value   = nv
        end
        ((n+1)...children.length).each do |i|
            children[i].label   = ""
            children[i].tooltip = "" if stride == 2
            children[i].value   = false
        end
        damage_self
    }

    function layout(l, selfBox) {
        children[0].fixed(l, selfBox, 0.9, 0.0, 0.1, 1.0)
        miniBox = nil
        if(selfBox.class != LayoutConstBox)
            miniBox = l.genBox :selminibox, nil
            l.fixed(miniBox, selfBox, 0.0, 0.0, 0.9, 1.0)
        else
            miniBox = l.genConstBox(0.0, 0.0, 0.9*selfBox.w, selfBox.h)
        end
        titleH  = 1.0/(children.length + 1)
        Draw::Layout::vpack(l, miniBox, children[1,99], 0, 1, 0, titleH, 1.0-titleH)
        selfBox
    }

    function selected()
    {
        return "" if(value_lab.nil?)
        return value_lab
    }

    function selected_val()
    {
        return "" if(value_sel.nil?)
        return value_sel
    }

    function selected_id()
    {
        self.children.each_with_index do |c,i|
            next       if c.class == Qml::ScrollBar
            return i-1 if c.value
        end
        nil
    }
}
