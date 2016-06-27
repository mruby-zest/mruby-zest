Widget {
    id: vce_list
    property Array weights: [0.05, 0.05, 0.2, 0.2, 0.3, 0.2]

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


    function onSetup(old=nil)
    {
        (0...8).each do |r|
            row        = Qml::ZynAddVoiceListItem.new(db)
            row.extern = "/part0/kit0/adpars/VoicePar#{r}/"
            row.num    = r
            Qml::add_child(self, row)
        end
    }

    Widget {
        //0
        ColorBox {bg: nil }
        //1
        ColorBox {bg: nil}
        //2
        TextBox  {bg: nil; label: "volume"}
        //3
        TextBox  {bg: nil; label: "panning"}
        //4
        TextBox  {bg: nil; label: "detune"}
        //5
        TextBox  {bg: nil; label: "vib-depth"}
        function layout(l)
        {
            selfBox = l.genBox :zavlh, self
            chBox   = []

            off = 0.0
            children.each_with_index do |ch, ind|
                weight = vce_list.weights[ind]
                box    = ch.layout(l)
                l.fixed(box, selfBox, off, 0.0, weight, 1.0)
                off += weight
            end
            selfBox
        }
    }

    function layout(l)
    {
        selfBox = l.genBox :zavlh, self
        n = children.length
        off  = 0
        gap  = 0.040
        step = (1.0-(n)*gap)/n
        children.each_with_index do |ch, id|
            chBox = ch.layout(l)
            l.fixed(chBox, selfBox, 0.01, off, 0.98, step)
            off += step + gap
        end
        selfBox
    }
}
