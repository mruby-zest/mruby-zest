Widget {
    id: hedit
    property Function whenValue: nil
    property Symbol   type: :oscil
    property Int      totalHarm: 128
    property Int      oldOff: 0
    property Int      curOff: 0

    function cb() { whenValue.call if whenValue }

    function clear()
    {
        children.each_with_index do |ch, i|
            mval = 64.1/127.0 if(type == :oscil)
            mval = 0/127.0  if(type == :subsynth)
            pval = 64.1/127.0
            mval = 1.0 if i == 0
            ch.children[0].value          = mval
            ch.children[0].valueRef.value = mval
            ch.children[2].value          = pval
            ch.children[2].valueRef.value = pval
        end
    }

    function animate()
    {
        return if(self.oldOff == self.curOff)
        off = self.curOff
        self.oldOff = self.curOff

        children.each_with_index do |ch, i|
            ii = (i+off).to_i.to_s
            ch.children[1].label = ii
            if(self.type == :oscil)
                ch.children[0].extern = self.extern + "magnitude" + ii
                ch.children[2].extern = self.extern + "phase"     + ii
            end
        end
        damage_self
    }

    function set_scroll(val)
    {
        len  = totalHarm - 32
        off  = 32*(val*len/32).to_i

        return if(self.oldOff == off)
        self.curOff = off
    }

    function onSetup(old=nil)
    {
        return if !children.empty?
        (0...32).each do |ev|
            hm           = Qml::HarmonicEditSingle.new(db)
            hm.num       = ev
            hm.extern    = self.extern
            hm.slidetype = self.type
            hm.whenValue = lambda {hedit.cb}
            Qml::add_child(self, hm)
        end
    }

    function layout(l)
    {
        selfBox = l.genBox :harmonicEdit, self

        n = children.length
        children.each_with_index do |ch, id|
            box = ch.layout(l)
            l.fixed(box, selfBox, id/n, 0, 1.0/n, 1.0)
        end

        selfBox
    }

    function draw(vg)
    {
        return
        vg.path do |v|
            v.rect(0,0,self.w,self.h)
            v.fill_color color("ff600f")
            v.fill
        end
    }
    
    function onMousePress(ev) {
        @active_widget  = root.activeWidget(ev.pos.x, ev.pos.y)
        @active_y       = ev.pos.y
        @active_buttons = ev.buttons
        return if @active_widget.class != Qml::Slider
        $remote.midi_learn @active_widget.extern if(root.learn_mode && @active_widget.extern)

        if(ev.buttons.include? :leftButton)
            @prev = ev.pos
        elsif(ev.buttons.include? :rightButton)
            if(children.empty?)
                @active_widget.create_radial
            end
        elsif(ev.buttons.include? :middleButton)
            @active_widget.reset
        else
            @prev = ev.pos
        end
    }

    function onMouseMove(ev) {
        fine = root.fine_mode ? 0.05 : 1.0
        nactive = root.activeWidget(ev.pos.x, ev.pos.y)
        if(@prev && @active_widget == nactive && @active_buttons.include?(:leftButton))
            delta = +(ev.pos.y - @prev.y)
            @active_widget.updatePos(fine*delta/@active_widget.dragScale)
            @prev = ev.pos
        elsif(@prev && @active_buttons.include?(:leftButton))
            @active_widget = :dummy
            nactive = root.activeWidget(ev.pos.x, @active_y)
            return if nactive.class != Qml::Slider
            val = (ev.pos.y-nactive.global_y)/nactive.h
            nactive.updatePosAbs(1-val)
        elsif(@active_buttons.include?(:middleButton))
            @active_widget = :dummy
            nactive = root.activeWidget(ev.pos.x, @active_y)
            return if nactive.class != Qml::Slider
            nactive.reset
        end
    }
}
