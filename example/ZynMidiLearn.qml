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
            chBox   = children.map {|c| c.layout l}

            Draw::Layout::hfill(l, selfBox, chBox, vce_list.weights)
        }
    }

    function layout(l)
    {
        selfBox = l.genBox :zavlh, self
        chldBox = children.map {|c| c.layout l}

        Draw::Layout::vpack(l, selfBox, chldBox)
    }
}
