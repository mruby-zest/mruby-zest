Object {
    //property Layout layout: parent.layout
    id: widget

    property Object parent: nil

    property Array children: []

    property String label: ""

    property Array layoutOpts: []

    property Int x: nil;
    property Int y: nil;
    property Int w: nil;
    property Int h: nil;

    function draw(vg)
    {
    }

    function onSetup(old=nil)
    {
    }

    function layout(l)
    {
        t = widget.class_name.to_sym
        selfBox = l.genBox t, widget
    }
    //

    function class_name()
    {
        "Widget"
    }

    function to_s(i=1)
    {
        base = "<"+widget.class_name()+"##{widget.ui_path}:" + widget.label
        child_s = []

        widget.children.each do |x|
            child_s << x.to_s(i+1)
        end

        if(child_s.empty?)
            base + ">"
        else
            base + "\n" + " "*i + "[" + child_s.join(", ") + "]>"
        end
    }
}
