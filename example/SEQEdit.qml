Widget {
    id: seqedit
    property Function whenValue: nil
    property Object   valueRef: nil
    property Symbol   type: :SEQ
    property Int      totalSteps: 128
    property Int      oldOff: 0
    property Int      curOff: 0

    function cb() { whenValue.call if whenValue }

    function clear()
    {
        children.each_with_index do |ch, i|
            mval = 0.0
            ch.children[0].value          = mval
            ch.children[0].valueRef.value = mval
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
            if(self.type == :SEQ)
                ch.children[0].extern = self.extern + "sequence" + ii
            end
        end
        damage_self
    }

    function set_scroll(val)
    {
        len  = totalSteps - 32
        off  = 32*(val*len/32).to_i

        return if(self.oldOff == off)
        self.curOff = off
    }
    
    function update_steps(x)
    {
        children.each_with_index do |ch, id|
            if id <= x
                ch.children[0].active = true
            else
                ch.children[0].active = false
            end
        end
    }

    function onSetup(old=nil)
    {
        return if !children.empty?
        (0...32).each do |ev|
            step           = Qml::SEQEditSingle.new(db)
            step.num       = ev
            step.extern    = self.extern
            step.slidetype = self.type
            step.whenValue = lambda {seqedit.cb}
            Qml::add_child(self, step)
        end
         
        self.valueRef = OSC::RemoteParam.new($remote, self.extern + "steps")
        self.valueRef.callback = lambda {|x| seqedit.update_steps(x)}
        update_steps(32)
    }

    function draw(vg) {
        return
        vg.path do |v|
            v.rect(0,0,self.w,self.h)
            v.fill_color color("cc900f")
            v.fill
        end
    }

    function onMousePress(ev) {
        @active_widget  = root.activeWidget(ev.pos.x, ev.pos.y)
        @active_y       = ev.pos.y
        @active_buttons = ev.buttons
        return if @active_widget.class != Qml::Slider
        $remote.automate(@active_widget.extern) if(root.learn_mode && @active_widget.extern)

        if(ev.buttons.include? :leftButton)
            @prev = ev.pos
            now = Time.new
            if (@click_time && (now-@click_time) < 0.400)
                @active_widget.reset
            end
            @click_time = now
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
        @active_buttons ||= []
        fine = root.fine_mode ? 0.05 : 1.0
        nactive = root.activeWidget(ev.pos.x, ev.pos.y)
        if(@prev && @active_widget == nactive && @active_buttons.include?(:leftButton))
            delta = +(ev.pos.y - @prev.y)
            return if nactive.class != Qml::Slider
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
    
    function layout(l, selfBox) {
        n = children.length*1.0
        children.each_with_index do |ch, id|
            ch.fixed(l, selfBox, id/n, 0, 1.0/n, 1.0)
        end
        selfBox
    }

}
