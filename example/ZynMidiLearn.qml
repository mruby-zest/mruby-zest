Widget {
    id: vce_list
    property Array weights: [0.05, 0.05, 0.05, 0.75, 0.05, 0.05]

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
        (0...16).each do |r|
            row = Qml::ZynMidiLearnRow.new(db)
            row.label = r.to_s
            row.weights = self.weights
            Qml::add_child(self, row)
        end
    }

    Widget {
        //0
        ColorBox {bg: nil}
        //1
        TextBox  {bg: nil; label: "ch"}
        //2
        TextBox  {bg: nil; label: "ctrl"}
        //3
        TextBox  {bg: nil; label: "acquired controls"}
        //4
        TextBox  {bg: nil; label: "min"}
        //5
        TextBox  {bg: nil; label: "max"}
        function layout(l)
        {
            selfBox = l.genBox :zavlh, self
            chBox   = children.map {|c| c.layout l}

            Draw::Layout::hfill(l, selfBox, chBox, vce_list.weights)
        }
    }

    function layout(l)
    {
        selfBox = l.genBox :zavlh, self
        n = children.length
        off  = 0
        gap  = 0.005
        step = (1.0-(n)*gap)/n
        children.each_with_index do |ch, id|
            chBox = ch.layout(l)
            l.fixed(chBox, selfBox, 0.01, off, 0.98, step)
            off += step + gap
        end
        selfBox
    }
}
