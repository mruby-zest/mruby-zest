Widget {
    property Float minimum: 0
    property Float maximum: 0

    function abs(x)
    {
        if x > 0
            x
        else
            -x
        end
    }

    function recalc()
    {
        @gain   ||= 1.0
        @offset ||= 0.5

        #function is out = @offset + input * @gain
        #function is over -1..1
        #function maps to 0..1

        #Calculate x=-1 y value
        ym = @offset + -1*@gain
        #Calculate x=1 y value
        yp = @offset + 1*@gain
        #Calculate y=0 x value
        xm = (0-@offset)/@gain
        #Calculate y=1 x value
        xp = (1-@offset)/@gain

        @points = []

        if(ym < 0)
            @points << [0.0, 0.0, (xm+1)/2, 0.0]
        elsif(ym > 1)
            @points << [0.0, 1.0, (xp+1)/2, 1.0]
        else
            @points << [0.0, ym]
        end
        
        if(yp < 0)
            @points << [(xm+1)/2, 0.0, 1.0, 0.0]
        elsif(yp > 1)
            @points << [(xp+1)/2, 1.0, 1.0, 1.0]
        else
            @points << [1.0, yp]
        end
        @points = @points.flatten
        damage_self
    }

    function set_offset(o)
    {
        @offset = o + 0.5
        recalc()
    }

    function set_gain(g)
    {
        @gain = g
        recalc()
    }

    function draw(vg)
    {
        @gain   ||= 1.0
        @offset ||= 0.5
        recalc() if(@points.nil?)
        background(color("222222"))

        
        vg.path do
            vg.move_to(0,h/2)
            vg.line_to(w,h/2)
            vg.stroke_color(color("777777"))
            vg.stroke_width(1)
            vg.stroke
        end
        
        vg.path do
            vg.move_to(w/2,0)
            vg.line_to(w/2,h)
            vg.stroke_color(color("777777"))
            vg.stroke_width(1)
            vg.stroke
        end
        
        vg.path do
            vg.move_to(0,0)
            vg.line_to(w,0)
            vg.line_to(w,h)
            vg.line_to(0,h)
            vg.line_to(0,0)
            vg.stroke_color(color("aaaaaa"))
            vg.stroke_width(1)
            vg.stroke
        end
        
        #Draw the actual line
        n = @points.length/2
        vg.path do
            vg.move_to(0,h)
            vg.move_to(w*@points[0], h*(1-@points[1]))
            (1...n).each do |p|
                vg.line_to(w*@points[2*p+0], h*(1-@points[2*p+1]))
            end
            vg.stroke_color(color("aaaaaa"))
            vg.stroke_width(2)
            vg.stroke
        end

        #Draw the active point
        input = 0.3
        out = @offset + input * @gain
        if(out > 0 && out < 1)
            vg.path do
                vg.circle((input+1)/2*w, (1-out)*h, 5)
                vg.stroke
            end
        end



    }
}
