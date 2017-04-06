Widget {
    id: box
    property Bool active: false

    onActive: {
        box.damage_self
    }


    function draw(vg)
    {
        scale = 0.5
        vg.path do
            vg.move_to((0.5-scale/2)*w,(0.5+scale/2)*h)
            vg.line_to((0.5-scale/2)*w,(0.5-scale/2)*h)
            vg.line_to((0.5+scale/2)*w,0.5*h)
            vg.close_path
            vg.fill_color(color("bbbbbb")) if !self.active
            vg.fill_color(color("55ff55")) if  self.active
            vg.fill
        end
    }
    
    function layout(l, selfBox) {
        l.aspect(selfBox, 1, 1)
        selfBox
    }
}
