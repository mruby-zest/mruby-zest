Widget {
    id: overtone
    function draw(vg) {
        vg.path do |v|
            v.rect(0,0,w,h)
            paint = v.linear_gradient(0,0,0,h,
            Theme::InnerGrad1, Theme::InnerGrad2)
            v.fill_paint paint
            v.fill
            v.stroke_color color(:black)
            v.stroke_width 1.0
            v.stroke
        end
    }
    Widget {
        //row 1
        TextBox  {bg: nil; label: "overtone pos."; height: 0.9}
        HSlider  {label: "bandwidth"; height: 0.8}
        HSlider  {label: "force.h"; height: 0.8}

        //row 2
        Selector {layoutOpts: [:no_constraint]}
        Widget {}
        Widget {}

        //row 3
        TextBox  {bg: nil; label: "spectral mode"; height: 0.9}
        TextBox  {bg: nil; label: "bw. scale"; height: 0.9}
        HSlider {label: "par1"; height: 0.8}

        //row 4
        Selector {
            layoutOpts: [:no_constraint];
            extern: overtone.extern + "Pmode"
        }
        Selector {layoutOpts: [:no_constraint]}
        HSlider {label: "par2"; height: 0.8}

        //1    2    3
        //4
        //5    6    7
        //8    9   10

        function class_name() { "overtone" }
        function layout(l) {
            Draw::Layout::grid(l, self_box(l), chBoxes(l), 4, 3, 1, 2)
        }
    }
    function layout(l)
    {
        selfBox = l.genBox :overtone, self
        chBox   = children[0].layout l
        pad = 4
        l.fixed_long(chBox, selfBox, 0, 0, 1, 1,
            pad, pad, -2*pad, -2*pad)
        selfBox
    }
}
