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

    function root()
    {
        if(parent.respond_to?(:root))
            parent.root
        else
            parent
        end
    }

    //(defun print-tree (tree &optional (offset 0))
    //  (loop for node in tree do
    //         (terpri)
    //                (loop repeat offset do (princ " |"))
    //                       (format t "-~a" (car node))
    //                              (print-tree (cdr node) (1+ offset))))
    function to_s(i=0)
    {
        out = ""
        i.times do 
            out += " |"
        end

        out += "- <"+widget.class_name()+"##{widget.ui_path}:" + widget.label
        out += ">\n"
        widget.children.each do |x|
            out += x.to_s(i+1)
        end

        out
    }
}
