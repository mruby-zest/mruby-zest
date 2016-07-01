Widget {
    id: vce_list
    property Array  weights: [0.05, 0.05, 0.05, 0.75, 0.05, 0.05]
    property Object valueRef: nil

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

        self.valueRef = OSC::RemoteParam.new($remote, "/midi-learn-values")
        self.valueRef.callback = lambda {|x| vce_list.handle(x) }
        self.valueRef.refresh
    }

    function handle(x)
    {
        n = x.length/4
        m = children.length-1
        (0...n).each do |i|
            row = children[i+1]
            row.children[1].label = "*"
            row.children[2].label = x[i*4+0].to_s
            row.children[3].label = x[i*4+1].to_s
            row.children[4].label = x[i*4+2].to_s
            row.children[5].label = x[i*4+3].to_s
        end
        (n...m).each do |i|
            row = children[i+1]
            row.children[1].label = "X"
            row.children[2].label = "X"
            row.children[3].label = ""
            row.children[4].label = "X"
            row.children[5].label = "X"
        end
        damage_self
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
        function class_name() { "zavlh" }
        function layout(l) {
            Draw::Layout::hfill(l, self_box(l), chBoxes(l), vce_list.weights)
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
