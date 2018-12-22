Widget {
    id: button
    property signal action: nil;
    property Bool   value:    false;
    property Bool   enable:   false
    tooltip: "Use Middle Mouse To Toggle"
    
    function onMouseEnter(ev) {
        if(self.tooltip != "")
            self.root.log(:tooltip, self.tooltip)
        end
    }

    function set_enable(v) {
        if(button.enable != v)
            button.enable = v
            damage_self
        end
    }

    function onMousePress(ev) {
        if(ev.buttons.include? :leftButton)
            action.call(:change_view) if action
        elsif(ev.buttons.include? :middleButton)
            action.call(:toggle) if action
        end
        damage_self
    }

    function onMerge(val)
    {
        button.value = val.value
    }

    function class_name()
    {
        "KitButton"
    }

    function layout(l, selfBox)
    {
        if(selfBox.nil?)
            t = widget.class_name.to_sym
            selfBox = l.genBox t, widget
        end
        selfBox
    }

    function draw(vg)
    {
        off_color     = Theme::ButtonInactive
        on_color      = Theme::ButtonActive
        outline_color = Theme::ButtonActive
        text_color1   = Theme::TextActiveColor
        text_color2   = color("B9CADE")
        background_color = Theme::VisualBackground

        #TODO check textcolor2 and outline
        pad = 0.05

        rect_x = (w*pad).round()
        rect_y = (h*pad).round()
        rect_w = (w*(1-2*pad)).round()
        rect_h = (h*(1-2*pad)).round()

        vg.translate(0.5, 0.5)

        vg.path do |v|
            v.rect(rect_x, rect_y, rect_w, rect_h)

            if(button.value)
                v.fill_color on_color
            else
                v.fill_color off_color
            end
            v.fill
            if(self.enable)
                v.stroke_color(outline_color)
                v.stroke_width 1
                v.stroke
            end
        end

        #inner rectangle when enabled
        if(self.enable)
            vg.path do |v|
                    v.stroke_color background_color

                    stroke_width = 1
                    v.stroke_width = stroke_width

                    v.rect(rect_x + stroke_width, rect_y + stroke_width, rect_w - stroke_width * 2, rect_h - stroke_width * 2)
                    v.stroke
            end
        end
        vg.translate(-0.5, -0.5)

        vg.font_face("bold")
        vg.font_size (h*0.65).to_i
        vg.text_align NVG::ALIGN_CENTER | NVG::ALIGN_MIDDLE
        if(self.enable)
            vg.fill_color(text_color1)
        else
            vg.fill_color(text_color2)
        end
        vg.text(w/2,h/2,button.label.upcase)
    }
}
