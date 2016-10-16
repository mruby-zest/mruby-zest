Widget {
    property Function whenValue: nil
    function draw(vg)
    {
        pad  = 1/64
        pad2 = (1-2*pad)
        vg.path do |v|
            v.rect(w*pad, h*pad, w*pad2, h*pad2)
            paint = v.linear_gradient(0,0,0,h,
            Theme::ButtonGrad1, Theme::ButtonGrad2)
            v.fill_paint paint
            v.fill
            v.stroke_width 1
            v.stroke
        end

        vg.path do |v|
            v.move_to(w*1/3, 0)
            v.line_to(w*1/3, h)
            v.move_to(w*2/3, 0)
            v.line_to(w*2/3, h)
            v.stroke
        end

        text_color = Theme::TextColor
        if self.layoutOpts.include? :aspect
            vg.font_size h*0.5 
        else
            vg.font_size h*0.8 
        end
        vg.fill_color text_color
        vg.path do |v|
            v.text_align NVG::ALIGN_CENTER | NVG::ALIGN_MIDDLE
            v.text(1/6*w,h/2,"Mn")
        end
        
        #Pause Icon
        vg.path do |v|
            v.text_align NVG::ALIGN_CENTER | NVG::ALIGN_MIDDLE
            v.text(3/6*w,h/2,"R")
        end
        
        #Play Icon
        vg.path do |v|
            v.text_align NVG::ALIGN_CENTER | NVG::ALIGN_MIDDLE
            v.text(5/6*w,h/2,"Mx")
        end
    }

    function onMouseHover(ev)
    {
        rel = (ev.pos.x-global_x)/w
        if(rel < 1/3)
            self.root.log(:tooltip, 
            "Capture minimum key")
        elsif(rel < 2/3)
            self.root.log(:tooltip, 
            "Reset key range")
        else
            self.root.log(:tooltip, 
            "Capture maximum key")
        end
    }

    function onMousePress(ev)
    {
        rel = (ev.pos.x-global_x)/w
        if(rel < 1/3)
            $remote.action(extern + "captureMin")
        elsif(rel < 2/3)
            $remote.action(extern + "Pminkey", 0)
            $remote.action(extern + "Pmaxkey", 127)
        else
            $remote.action(extern + "captureMax")
        end
        whenValue.call if whenValue
    }

    function layout(l)
    {
        s = self_box(l)
        if(self.layoutOpts.include? :aspect)
            l.aspect(s, 1.0, 3.0)
        end
        s
    }
}
