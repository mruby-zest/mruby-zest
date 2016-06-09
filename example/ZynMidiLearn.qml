Widget {
    id: vce_list
    property Array weights: [0.05, 0.05, 0.05, 0.75, 0.05, 0.05]

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
        ColorBox {bg: Theme::TitleBar}
        //1
        TextBox  {bg: Theme::TitleBar; label: "ch"}
        //2
        TextBox  {bg: Theme::TitleBar; label: "ctrl"}
        //3
        TextBox  {bg: Theme::TitleBar; label: "aquired controls"}
        //4
        TextBox  {bg: Theme::TitleBar; label: "min"}
        //5
        TextBox  {bg: Theme::TitleBar; label: "max"}
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
        children.each_with_index do |ch, id|
            chBox = ch.layout(l)
            l.fixed(chBox, selfBox, 0, id/n, 1, 1/n)
        end
        selfBox
    }
}
