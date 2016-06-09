Widget {
    ColorBox {
        bg: color("ff0000")
        function vpack(l, selfBox, b, x=0, w=0)
        {
            off = 0
            n = b.length
            b.each_with_index do |bb,i|
                l.fixed(bb, selfBox, x, off, w,  1.0/n)
                off += 1.0/n
            end
            selfBox
        }

        function onSetup(old=nil)
        {
            return if !children.empty?
            (1..16).each do |i|
                but = Qml::Button.new(self.db)
                but.label = i.to_s
                but.layoutOpts = [:no_constraint]
                Qml::add_child(self, but)
            end
            (1..16).each do |i|
                but = Qml::Button.new(self.db)
                but.label = "None"
                but.layoutOpts = [:no_constraint]
                Qml::add_child(self, but)
            end
        }

        function layout(l)
        {
            selfBox = l.genBox :part, self
            rows = children.map {|x| x.layout l}
            vpack(l, selfBox, rows[0..15],  0.0, 0.2)
            vpack(l, selfBox, rows[16..31], 0.2, 0.8)
        }
    }
    ColorBox { 
        bg: color("ffff00")
        function vfill(l, selfBox, b, h)
        {
            off = 0
            b.each_with_index do |bb,i|
            l.fixed(bb, selfBox, 0, off, 1,  h[i])
            off += h[i]
            end
            selfBox
        }
        function layout(l)
        {
            selfBox = l.genBox :part, self
            rows = children.map {|x| x.layout l}
            vfill(l, selfBox, rows, [0.4,0.3,0.3])
        }
        ZynInstrumentSettings {}
        ZynControllers {}
        ZynPortamento  {}
    }
    ColorBox {
        bg: color("ff00ff")
        function vfill(l, selfBox, b, h)
        {
            off = 0
            b.each_with_index do |bb,i|
            l.fixed(bb, selfBox, 0, off, 1,  h[i])
            off += h[i]
            end
            selfBox
        }
        function layout(l)
        {
            selfBox = l.genBox :part, self
            rows = children.map {|x| x.layout l}
            vfill(l, selfBox, rows, [0.2,0.15,0.65])
        }
        ColorBox { bg: color("ff0000")}
        ColorBox { bg: color("00ff00")}
        ColorBox { bg: color("0000ff")}
    }

    function hfill(l, selfBox, b, w)
    {
        off = 0
        b.each_with_index do |bb,i|
            l.fixed(bb, selfBox, off, 0, w[i], 1)
            off += w[i]
        end
        selfBox
    }

    function layout(l)
    {
        selfBox = l.genBox :part, self
        cols = children.map {|x| x.layout l}
        hfill(l, selfBox, cols, [0.2,0.4,0.4])
    }
}
