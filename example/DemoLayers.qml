Widget {
    id: demo

    function draw(vg)
    {
        vg.path do |v|
            v.rect(0,0,w,h)
            grad = v.linear_gradient(0,0,512,512,NVG.rgba(0,0,0,255),
            NVG.rgba(rand(255),rand(255),rand(255),255))
            v.fill_paint = grad
            v.fill
        end
    }

    function onMousePress(ev) { }

    function onMouseHover(ev)
    {
        #pos = ev.pos
        #drect = Rect.new(pos.x-2, pos.y-2, 16, 16)
        #root.draw_damage(drect, demo.layer)
    }

    Knob {
        x: 100
        y: 200
        w: 100
        h: 100
    }
    Knob{
        x: 300
        y: 200
        w: 100
        h: 100
    }
    Knob{
        x: 400
        y: 200
        w: 100
        h: 100
    }
    Knob{
        x: 400
        y: 300
        w: 100
        h: 100
    }
}
