Widget {
    id: kit
    //0.2
    //                       0     1     2     3     4     5     6     7     8
    property Array weights: [0.05, 0.19, 0.15, 0.10, 0.15, 0.07, 0.07, 0.07, 0.15]

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
        TextBox  {bg: Theme::TitleBar; label: "add"}
        //6
        TextBox  {bg: Theme::TitleBar; label: "sub"}
        //7
        TextBox  {bg: Theme::TitleBar; label: "pad"}
        //8
        TextBox  {bg: Theme::TitleBar; label: "effect route"}
        function layout(l) {
            Draw::Layout::hfill(l, self_box(l), chBoxes(l), kit.weights, 0, 3)
        }
    }

    function class_name() { "kits" }
    function layout(l) {
        Draw::Layout::vpack(l, self_box(l), chBoxes(l), 0, 1, 2)
    }
}
