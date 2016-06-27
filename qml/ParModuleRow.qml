Widget {
    id: row
    property Float lsize: 0.3
    property Int   whitespace: nil
    property Symbol outer: nil


    function onSetup(old=nil) {
        mch = row.children
        cch = content.children
        if(mch.length > 2)
            cch = cch+mch[2..-1]
            mch = mch[0..1]
            content.children = cch
            row.children     = mch
        else
        end

        n = content.children.length
        labels.children = []
        (0...n).each do |i|
            label = createInstance("Text", labels, row.db)
            label.height = 0.7
            label.layoutOpts = [:ignoreAspect]
            if(content.children[i].class_name != "Button")
                label.label = content.children[i].label
            end
        end
    }

    function layout_hpack(l, selfBox, box, children, mode, breal=nil)
    {
        #Create A list of boxes
        blist = []
        return blist if children.empty?
        fixed_height = nil
        fixed_width  = nil
        if(mode == :labels)
            fixed_height = l.gensym :modlabelHeight
            #fixed_width  = l.gensym :modWidgetWidth
        else
            fixed_width  = l.gensym :modWidgetWidth
        end
        begin
            prev = nil
            children.each_with_index do |ch, i|
                bb = ch.layout(l)
                if(bb)
                    l.sheq([bb.x], [1], 0) if i==0 && outer == :none
                    blist << bb
                    l.contains(box, bb)
                    if(mode == :labels)
                        l.sheq([fixed_height, bb.h], [1, -1], 0)
                        #l.sheq([fixed_width,  bb.w], [1, -1], 0)
                    else
                        l.sheq([fixed_width,  bb.w], [1, -1], 0)
                    end
                    if(prev)
                        l.rightOf(prev, bb, i != whitespace)
                    end


                    l.weak(bb.x) if(i == whitespace)
                    prev = bb
                    l.sheq([bb.x, bb.w, selfBox.w], [1, 1, -1], 0) if i==children.length-1 && outer == :none
                end
            end
        end

        #Punish Different Widths
        if(mode == :normal)
            blist.each do |x|
                l.punish2([selfBox.w], [1.0/blist.length], x.w)
            end

            #Punish floating in the y dir
            blist.each do |x|
                l.weak(x.y)
            end
        end

        #Center Stuff Horizontally
        if(!blist.empty? && whitespace.nil?)
            l.sheq([blist[0].x, selfBox.w, blist[-1].x, blist[-1].w],
            [1,       -1,       1,     1], 0)
        end

        content_items = blist
    }

    function layout(l)
    {
        selfBox    = l.genBox :parmodulerow, row
        contentBox = content.layout(l)
        labelBox   = labels.layout(l)

        #Constrain Content Box
        l.contains(selfBox,contentBox)
        l.contains(selfBox,labelBox)
        l.topOf(contentBox,labelBox)

        l.sh([contentBox.h, selfBox.h], [1, -(1-lsize)], 0)
        l.sheq([contentBox.w, selfBox.w], [1, -1],   0)
        l.sh([labelBox.h,   selfBox.h], [1, -lsize], 0)
        l.sheq([labelBox.w,   selfBox.w], [1, -1],   0)

        content_items = layout_hpack(l, selfBox, contentBox, row.content.children, :normal)
        label_items   = layout_hpack(l, selfBox, labelBox,   row.labels.children,  :labels,
                                     content_items)


        if(label_items.length == content_items.length)
            n = label_items.length
            (0...n).each do |i|
                li = label_items[i]
                ci = content_items[i]
                l.sheq([li.x, li.w, ci.x, ci.w],
                       [1, 0.5, -1, -0.5], 0)
            end
        end
        selfBox
    }

    Widget {
        id: content
        function class_name() { "ContentBox" }
    }
    Widget {
        id: labels
        function class_name() { "LabelBox" }
    }
}
