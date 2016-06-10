Widget {
    ColorBox {bg: color("aa44cc")}
    ColorBox {
        ColorBox {bg: color("123456")}
        ColorBox {bg: color("654321")}
        function layout(l)
        {
            selfBox = l.genBox :effvert, self
            Draw::Layout::vfill(l, selfBox, children.map {|x| x.layout l}, [0.4, 0.6])
        }
    }
    function layout(l)
    {
        selfBox = l.genBox :eff, self
        Draw::Layout::hfill(l, selfBox, children.map {|x| x.layout l}, [0.1, 0.9])
    }
}
