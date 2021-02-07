Widget {
    id: selector
    property Object valueRef: nil;
    property String extern: ""
    property Array  options: ["text", "test", "asdf"];
    property Array  opt_vals: []
    property Int    selected: 0
    property Bool   active:   true
    property Function whenValue: nil
    property Int    max_text: 8

    onExtern: {
        meta = OSC::RemoteMetadata.new($remote,
                                       selector.extern)
        selector.label   = meta.short_name
        selector.tooltip = meta.tooltip
        if(meta.options)
            nopts = []
            vals  = []
            meta.options.each do |x|
                vals  << x[0]
                nopts << x[1]
            end
            selector.options = nopts
            selector.opt_vals = vals
        end
        selector.valueRef = OSC::RemoteParam.new($remote, selector.extern)
        selector.valueRef.mode = :options
        selector.valueRef.callback = Proc.new {|x| selector.set_value(x)}
    }

    function refresh() {
        self.valueRef.refresh if self.valueRef
    }

    function set_value(x)
    {
        sel = 0
        opt_vals.each_with_index do |i, ind|
            sel = ind if i == x
        end

        self.selected = sel
        rt = self.root
        rt.damage_item self if rt
        whenValue.call if whenValue
    }

    function aspect2(box, ww, hh)
    {
        provided    = box.w/box.h
        recommended = ww/hh
        if(recommended > provided)
            #Decrease height
            new_height = box.h*provided/recommended
            box.y += (box.h-new_height)/2
            box.h = new_height
        else
            new_width = box.w*recommended/provided
            box.x += (box.w-new_width)/2
            box.w  = new_width
        end
    }

    function layout(l, selfBox)
    {
        if(!layoutOpts.include?(:no_constraint))
            scale = 100
            $vg.font_size scale
            bb = 1
            long_mode = layoutOpts.include?(:long_mode)
            selector.options.each do |x|
                x = x[0..self.max_text] if x.length > self.max_text && !long_mode
                bbl  = $vg.text_bounds(0, 0, (x+"    ").upcase)
                bb   = [bb, bbl].max
            end
            scale *= layoutOpts[0] if layoutOpts.include?(:rescale)
            if(bb != 0)
                #Width cannot be so small that letters overflow
                self.aspect2(selfBox, bb, scale)
            end
        end
        selfBox
    }

    function class_name()
    {
        "Selector"
    }

    function set_value_user(val)
    {
        if(val.nil?)
            damage_self
            return
        end
        return if(val == self.selected)
        self.selected = val
        if(self.valueRef && self.selected <= opt_vals.length)
            self.valueRef.value = self.opt_vals[self.selected]
        end
        if(self.valueRef && self.root)
            self.root.log(:user_value, self.valueRef.display_value, src=self.label)
        end
        whenValue.call if whenValue

        damage_self
    }

    function onMousePress(ev)
    {
        create_menu if self.active && options.length != 1
    }

    function draw_strike(vg)
    {
        pad  = 1.0/64
        pad2 = (1-2*pad)
        vg.path do
            vg.move_to(w*pad, h*pad)
            vg.line_to(w*pad2, h*pad2)
            vg.stroke_color Theme::TextColor
            vg.stroke_width 1
            vg.stroke
        end
    }

    function draw_arrow(vg)
    {
        pad  = 1.0/64
        pad2 = (1-2*pad)

        vg.path do |v|
            tx = w*pad2-h*pad2
            tw = h*pad2
            ty = h*pad
            th = h*pad2

            v.move_to(tx+0.25*tw, ty+0.3*th)
            v.line_to(tx+0.50*tw, ty+0.7*th)
            v.line_to(tx+0.75*tw, ty+0.3*th)
            v.close_path

            v.fill_color Theme::TextColor
            v.fill
        end
    }

    function draw_button(vg)
    {
        pad  = 1.0/64
        pad2 = (1-2*pad)
        vg.path do |v|
            v.rounded_rect(w*pad, h*pad, w*(1-2*pad), h*(1-2*pad), 2)
            paint = v.linear_gradient(0,0,0,h, Theme::ButtonGrad1, Theme::ButtonGrad2)
            v.fill_paint paint
            v.fill
            v.stroke_width 1
            v.stroke
        end

        vg.path do |v|
            hh = h/20
            v.move_to(w*pad+2,       h*pad+hh)
            v.line_to(w*(1-2*pad)+1, h*pad+hh)
            v.stroke_color color("5c5c5c")
            v.stroke_width hh
            v.stroke
        end
    }

    function draw(vg)
    {
        draw_button(vg)

        draw_arrow(vg) if options.length != 1

        draw_strike(vg) if !self.active

        return if options[selected].nil?

        pad  = 1.0/64
        text_color = Theme::TextColor

        vg.font_face("bold")
        vg.font_size h*0.8
        vg.text_align NVG::ALIGN_LEFT | NVG::ALIGN_MIDDLE
        vg.fill_color text_color

        long_mode = layoutOpts.include?(:long_mode)
        str = options[selected].upcase
        str = str[0..self.max_text] if str.length > self.max_text && !long_mode

        vg.text(3+w*pad*2,h/2, str)
    }

    function onScroll(ev)
    {
        return if !self.active
        i = self.selected
        i = i + (ev.dy > 0 ? -1 : 1)
        if ((i > -1) && (i < opt_vals.length))
            set_value_user(i)
        end
    }

    function create_menu()
    {
        n = options.length
        return if n < 1
        widget = Qml::DropDown.new(self.db)
        widget.w = self.w
        widget.h = self.h*n
        widget.x = 0
        widget.y = 0
        widget.layer = 2
        widget.options = options
        widget.callback = lambda { |v|
            set_value_user(v)
        }
        #Check if it's too big
        if(widget.h+global_y > window.h)
            if(global_y - self.h*(n-1) < 0)
                if(global_y > window.h*0.5)#upper
                    widget.h = (global_y+self.h)
                    widget.y = -global_y
                else#lower
                    widget.h = (window.h-global_y)
                end
            else
                widget.y = -self.h*(n-1)
            end
        end
        widget.prime(root())

        Qml::add_child(self, widget)
        root.smash_draw_seq
        root.damage_item widget
    }

}
