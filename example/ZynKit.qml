Widget {
    id: kit
    //                       0     1     2     3     4     5     6     7     8
    property Array weights: [0.05, 0.10, 0.10, 0.10, 0.05, 0.10, 0.10, 0.10, 0.30]

    function onSetup(old=nil)
    {
        puts "Zyn Kit Setup..."
        (0...16).each do |r|
            row = Qml::ZynKitRow.new(db)
            row.label = r.to_s
            row.weights = self.weights
            Qml::add_child(self, row)
        end
    }

    Widget {
        //0 - kit sel button
        ColorBox {bg: Theme::TitleBar}
        //1 - text field
        TextBox  {bg: Theme::TitleBar; label: "kit name"}
        //2
        TextBox  {bg: Theme::TitleBar; label: "minimum key"}
        //3
        TextBox  {bg: Theme::TitleBar; label: "last note"}
        //4
        TextBox  {bg: Theme::TitleBar; label: "maximum key"}
        //5
        TextBox  {bg: Theme::TitleBar; label: "addsynth"}
        //6
        TextBox  {bg: Theme::TitleBar; label: "subsynth"}
        //7
        TextBox  {bg: Theme::TitleBar; label: "padsynth"}
        //8
        TextBox  {bg: Theme::TitleBar; label: "effect route"}
        function layout(l)
        {
            selfBox = l.genBox :widget, self
            chBox   = children.map {|c| c.layout l}

            Draw::Layout::hfill(l, selfBox, chBox, kit.weights)
        }
    }

    function layout(l)
    {
        selfBox = l.genBox :kits, self
        chldBox = children.map {|c| c.layout l}

        Draw::Layout::vpack(l, selfBox, chldBox)
    }
}
