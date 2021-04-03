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
            next if !ch.respond_to?(:num)
            ii = (i-1+off).to_i.to_s
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
        children.each do |ch|
            next if !ch.respond_to?(:num)
            if (ch.num <= (x*127).to_i)
                ch.children[0].active = true
            else
                ch.children[0].active = false
            end
        end
        damage_self
    }

    function onSetup(old=nil)
    {
        return if children.length() > 1
        (0...32).each do |ev|
            step           = Qml::SEQEditSingle.new(db)
            step.num       = ev
            step.extern    = self.extern
            step.slidetype = self.type
            step.whenValue = lambda {seqedit.cb}
            Qml::add_child(self, step)
        end
         
        self.valueRef = OSC::RemoteParam.new($remote, self.extern + "steps")
        self.valueRef.callback = lambda {|x| self.update_steps(x)}
        self.valueRef.mode = :options
        self.valueRef.refresh
        self.update_steps(1)
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
        n = (children.length-1)*1.0
        children.each_with_index do |ch, id|
            if id == 0
                ch.fixed(l, selfBox, 0, 0, 1.0, 1.0)
            else
                ch.fixed(l, selfBox, ch.num/n, 0, 1.0/n, 1.0)
            end
        end
        selfBox
    }
    
    Widget {
        id: run_view
        //animation layer
        layer: 1

        //extern is cloned
        extern: seqedit.extern + "out"

        function class_name()
        {
            "SEQEditAnimation"
        }

        //Workaround due to buggy nested properties
        function valueRef=(value_ref)
        {
            @value_ref = value_ref
        }

        function valueRef()
        {
            @value_ref
        }

        function runtime_points()
        {
            @runtime_points
        }
        function runtime_points=(pts)
        {
            @runtime_points = pts
        }

        onExtern: {
            return if run_view.extern.nil?

            run_view.valueRef = OSC::RemoteParam.new($remote, run_view.extern)
            run_view.valueRef.set_watch
            run_view.valueRef.callback = Proc.new {|x|
                 if(run_view.runtime_points != x)
                    run_view.runtime_points = x;
                    run_view.damage_self
                end
            }
        }

        function animate() {
            return if run_view.valueRef.nil?
            run_view.valueRef.watch run_view.extern
        }

        function draw(vg)
        {
            #Draw the data
            pts   = @runtime_points
            pts ||= []


            scale = case root.get_view_pos(:subsubview)
                when :amplitude
                    1.0
                when :frequency
                    1.0/4096.0
                when :filter
                    1.0/4.0
                end
            pts.each_with_index do |pt, id|
                pts[id] *= scale if id%2==1
            end
            Draw::WaveForm::overlay(vg, Rect.new(w/64,2,w*4,(h-14)/2), pts)
        }
    }

}
