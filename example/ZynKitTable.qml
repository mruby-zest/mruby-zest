Widget {
    id: kittable
    //0.2
    //                       0     1     2     3     4     5     6     7     8
    property Array weights: [0.05, 0.19, 0.15, 0.10, 0.15, 0.07, 0.07, 0.07, 0.15]
    property Bool  active: true

    function onSetup(old=nil)
    {
        return if children.length > 2
        (0...16).each do |r|
            row         = Qml::ZynKitRow.new(db)
            row.label   = (r+1).to_s
            row.kitnum  = r
            row.weights = self.weights
            row.extern  = kittable.extern + "kit#{r}/"
            row.extern()
            row.set_active(false) if !self.active && r != 0
            Qml::add_child(self, row)
        end
    }

    Widget {
        //0 - kit sel button
        ColorBox {bg: Theme::TitleBar}
        //1 - text field
        TextBox  {bg: Theme::TitleBar; label: "kit name"}
        //2
        TextBox  {bg: Theme::TitleBar; label: "min. key"}
        //3
        TextBox  {bg: Theme::TitleBar; label: "last note"}
        //4
        TextBox  {bg: Theme::TitleBar; label: "max. key"}
        //5
        TextBox  {bg: Theme::TitleBar; label: "add"}
        //6
        TextBox  {bg: Theme::TitleBar; label: "sub"}
        //7
        TextBox  {bg: Theme::TitleBar; label: "pad"}
        //8
        TextBox  {bg: Theme::TitleBar; label: "effect route"}
        function layout(l, selfBox) {
            Draw::Layout::hfill(l, selfBox, children, kittable.weights, 0, 3)
        }
    }

    function class_name() { "kittable" }
    function layout(l, selfBox) {
        Draw::Layout::vpack(l, selfBox, children, 0, 1, 2)
    }

    function set_active_kit()
    {
        self.active = true
        return if children.length < 3
        children[2..-1].each do |c|
            c.set_active(true)
        end
    }

    function set_non_kit()
    {
        self.active = false
        return if children.length < 3
        children[2..-1].each do |c|
            c.set_active(false)
        end
    }
}
