Widget {
    layer: 2
    property Float value: 0.0
    property Bool  spin:  false

    function animate()
    {
        return if !self.spin
        self.value += 0.01
        self.value -= 1.0 if self.value > 1.0
        damage_self
    }

    function draw(vg)
    {
        pi = 3.14159
        start = 2*pi
        end_   = 0
        radius  = 0.25*[h*1.0,w].min
        inner  = 0.30*[h*1.0,w].min
        outer = 0.50*[h*1.0,w].min

        #lowest point is 0.707 cy-outer*0.707
        #shift by 0.293/2 to compinsate
        cy = h/2
        cx = w/2;
        kr = h/4;
        vg.path do |v|
            v.arc(cx, cy, outer, start, end_, 1);
            v.arc(cx, cy, inner, end_, start, 2);
            v.close_path
            v.fill_color(color("114575"))
            v.fill
        end

        return if !self.spin
        self.value = 0.0 if(self.value.class != Float)
        cang  = 2*pi*value

        width = 0.4

        len = (3.0/2.0*pi)*width;
        startt = 2*pi*value + len;

        vg.path do |v|
            v.arc(cx, cy, inner, cang, startt, 2);
            v.arc(cx, cy, outer, startt, cang, 1);
            v.close_path
            v.fill_color(color("3AC5EC"))
            v.fill
        end
    }
}
