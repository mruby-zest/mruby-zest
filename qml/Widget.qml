Object {
    //property Layout layout: parent.layout
    id: widget

    property Object parent: nil

    property Array children: []

    property String label: ""

    property String tooltip: ""

    property Array layoutOpts: []

    property String extern: ""

    property Int layer: 0;

    property Int x: nil;
    property Int y: nil;
    property Int w: nil;
    property Int h: nil;

    function draw(vg)
    {}

    function onSetup(old=nil)
    {
    }

    function layout(l, selfBox)
    {
        widget.children.each do |child|
            if(child.respond_to?(:layout))
                nbox = l.genConstBox(0, 0,
                    selfBox.w, selfBox.h, child)
                child.layout(l, nbox)
            end
        end

        selfBox
    }

    function fixed(l, pbox, xc, yc, wc, hc)
    {
        box = nil
        selfBox = l.genConstBox(pbox.w*xc, pbox.h*yc, pbox.w*wc, pbox.h*hc, self)
        box = self.layout(l, selfBox)
        box
    }

    function fixed_long(l, pbox, xc, yc, wc, hc, xf, yf, wf, hf)
    {
        l.fixed_long(self, pbox, xc, yc, wc, hc, xf, yf, wf, hf)
    }

    function damage_self(all=nil)
    {
        rt = self.root
        rt.damage_item(self, all) if rt
    }

    //Utility methods
    function background(c)
    {
        $vg.path do |v|
            v.rect(0,0,w,h)
            v.fill_color c
            v.fill
        end
    }

    function class_name() {
        "Widget"
    }

    function window() {
        if(parent.respond_to?(:root))
            parent.window
        else
            self
        end
    }

    function root() {
        if(parent.respond_to?(:root))
            parent.root
        else
            parent
        end
    }

    function global_x() {
        par = 0
        if(parent.respond_to?(:global_x))
            par = parent.global_x
        end
        par + widget.x
    }

    function global_y() {
        par = 0
        if(parent.respond_to?(:global_y))
            par = parent.global_y
        end
        par + widget.y
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

    function abs_x()
    {
        p = parent
        if(p.respond_to?(:root))
            widget.x + p.abs_x
        else
            widget.x
        end
    }

    function abs_y()
    {
        p = parent
        if(p.respond_to?(:root))
            widget.y + p.abs_y
        else
            widget.y
        end
    }
    
    function onMouseEnter(ev) {
        if(self.tooltip != "" and self.root.respond_to?(:log))
            self.root.log(:tooltip, self.tooltip)
        end
    }

    function onMouseLeave(ev)
    {
        if (self.root.respond_to?(:log))
            self.root.log(:tooltip, "")
        end
    }

}
