Widget {
    id: numentry
    property Function whenValue: nil
    property Int      value: 0
    property Object   valueRef: nil
    property String   format:   ""

    property Int      offset: 0
    property Int      minimum: 0
    property Int      maximum: 10
    
    property Bool     active: true

    onExtern: {
        meta = OSC::RemoteMetadata.new($remote, numentry.extern)
        numentry.label   = meta.short_name
        numentry.tooltip = meta.tooltip
        numentry.minimum = meta.min.to_i
        numentry.maximum = meta.max.to_i

        numentry.valueRef = OSC::RemoteParam.new($remote, numentry.extern)
        numentry.valueRef.mode     = :full
        numentry.valueRef.callback = Proc.new {|x| numentry.setValue(x)}

    }

    function class_name() {"num_entry"}
    function layout(l)
    {
        t = widget.class_name.to_sym
        selfBox = l.genBox t, self
        return selfBox if layoutOpts.include?(:free)

        #Assume all digit bounding boxes are roughly the same
        scale = 100
        $vg.font_size scale
        bb = $vg.text_bounds(0, 0, "- 9999 +")
        l.sh([selfBox.w, selfBox.h], [-1.0, bb/scale], 0)

        selfBox
    }

    function refresh() {
        self.valueRef.refresh if self.valueRef
    }

    function draw(vg)
    {
        textHeight = 0.8
        vg.path do
            vg.rect(0, 0, w, h)
            paint = vg.linear_gradient(0,0,0,h,
                Theme::ButtonGrad1, Theme::ButtonGrad2)
            vg.fill_paint paint
            vg.fill
            vg.stroke_width 1
            vg.stroke
        end

        vg.path do
            vg.move_to(0.2*w, 0*h)
            vg.line_to(0.2*w, 1*h)
            vg.move_to(0.8*w, 0*h)
            vg.line_to(0.8*w, 1*h)
            vg.stroke
        end

        vg.font_face("bold")
        vg.font_size h*textHeight
        vg.fill_color Theme::TextColor
        vg.text_align NVG::ALIGN_CENTER | NVG::ALIGN_MIDDLE
        vg.text(0.1*w,h/2,"-")
        vg.text(0.9*w,h/2,"+")
        vg.text(0.5*w,h/2,self.format+self.value.to_s)

        if(!self.active)
            pad = 0
            vg.path do
                vg.move_to(w*pad, h*pad)
                vg.line_to(w*(1-2*pad), h*(1-2*pad))
                vg.stroke_color Theme::TextColor
                vg.stroke
            end
        end
    }

    function setValue(val)
    {
        self.value = val + offset
        damage_self
    }

    function updatePos(delta)
    {
        return if !self.active
        if self.value + delta > maximum
            self.value = maximum
            return
        end
        if self.value + delta < minimum
            self.value = minimum
            return
        end
        self.value += delta
        if(self.valueRef)
            self.valueRef.value = self.value - offset
        end
        whenValue.call if whenValue
        damage_self
    }

    function onScroll(ev)
    {
        updatePos(+1) if ev.dy > 0
        updatePos(-1) if ev.dy < 0
    }

    function onMouseEnter(ev) {
        if(self.tooltip != "")
            self.root.log(:tooltip, self.tooltip)
        end
    }

    function onMousePress(ev)
    {
        return if !ev.buttons.include? :leftButton
        if(ev.pos.x-global_x > 0.5*w)
            updatePos(+1)
        else
            updatePos(-1)
        end
    }
}
