Widget {
    id: box
    property Bool  active: true
    property Value value: false
    property Function whenValue: nil;

    function onMousePress(ev) {
        return if !self.active
        self.value = 1.0
        whenValue.call if whenValue
        damage_self
    }

    function animate()
    {
        return if self.value == 0
        return if self.value == false
        return if self.value == true
        self.value *= 0.9
        self.value  = 0 if self.value < 0.02
        damage_self
    }

    function draw(vg)
    {
        off_color     = Theme::ButtonInactive
        on_color      = Theme::ButtonActive
        cs = 0
        pad = 1.0/64
        vg.path do |v|
            v.rounded_rect(w*pad, h*pad, w*(1-2*pad), h*(1-2*pad), 2)
            if(self.value == true)
                cs = 1
                v.fill_color on_color
            elsif(self.value.class == Float && self.value != 0)
                cs = 2
                t = self.value
                on = on_color
                of = Theme::ButtonGrad1
                v.fill_color(color_rgb(on.r*t + of.r*(1-t),
                                       on.g*t + of.g*(1-t),
                                       on.b*t + of.b*(1-t)))
            else
                paint = v.linear_gradient(0,0,0,h,
                Theme::ButtonGrad1, Theme::ButtonGrad2)
                v.fill_paint paint
            end
            v.fill
            v.stroke_width 1
            v.stroke

        end

        pad = 1.0/4

        vg.stroke_color(color("bbbbbb")) #if !self.active
        #vg.stroke_color(color("55ff55")) if  self.active
        vg.path do
            vg.move_to(1+pad*w,     1+pad*h)
            vg.line_to((1-pad)*w-1, (1-pad)*h-1)
            vg.stroke
        end
        vg.path do
            vg.move_to((1-pad)*w-1,  1+pad*h)
            vg.line_to(1+pad*w,     (1-pad)*h-1)
            vg.stroke
        end
    }

    function layout(l, selfBox) {
        l.aspect(selfBox, 1, 1)
        selfBox
    }
}
