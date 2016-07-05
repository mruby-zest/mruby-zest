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
        TextBox  {label: "overtone pos."; height: 0.9}
        HSlider  {extern: overtone.extern + "Pbandwidth";  height: 0.8}
        HSlider  {extern: overtone.extern + "Phrpos.par3"; height: 0.8}

        //row 2
        Selector {
            extern: overtone.extern + "Phrpos.type";
            layoutOpts: [:no_constraint]
        }
        Widget {}
        Widget {}

        //row 3
        TextBox  {label: "spectral mode"; height: 0.9}
        TextBox  {label: "bw. scale"; height: 0.9}
        HSlider {extern: overtone.extern + "Phrpos.par1"; height: 0.8}

        //row 4
        Selector {
            layoutOpts: [:no_constraint];
            extern: overtone.extern + "Pmode"
        }
        Selector {
            layoutOpts: [:no_constraint]
            extern: overtone.extern + "Pbwscale"
        }
        HSlider {extern: overtone.extern + "Phrpos.par2"; height: 0.8}

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
