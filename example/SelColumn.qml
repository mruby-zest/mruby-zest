Widget {
    id: col
    property Bool number: false
    function onSetup(old=nil)
    {
        rows = 24
        (rows).times do |x|
            ch = if(number)
                Qml::NumberButton.new(db)
            else
                Qml::Button.new(db)
            end
            ch.label = Pokemon[x]
            ch.layoutOpts = [:no_constraint]
            ch.number = x if number
            Qml::add_child(self, ch)
        end

    }

    function draw(vg)
    {
        pad  = 1/128.0
        pad2 = (1-2*pad)
        vg.path do |v|
            v.rect(pad*w,pad*h,pad2*w,pad2*h)
            v.fill_color color("123456")
            v.fill
        end
    }

    function layout(l)
    {
        selfBox = l.genBox :effvert, self
        Draw::Layout::vpack(l, selfBox, children.map {|x| x.layout l})
    }
}
