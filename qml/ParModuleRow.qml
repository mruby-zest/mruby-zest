Widget {
    id: row
    property Float lsize: 0.3
    property Int   whitespace: nil
    property Symbol outer: nil
    layoutOpts: [:fixed_width]


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
            label.height = 1.0
            label.layoutOpts = [:ignoreAspect]
            if(content.children[i].class_name != "Button")
                label.label = content.children[i].label
            end
        end
    }

    function layout_hpack(l, selfBox, children, mode, breal=nil)
    {
        #Create A list of boxes
        blist = []
        return blist if children.empty?
        weight_list = []
        bbs = []
        begin
            prev = nil
            n = children.length
            children.each_with_index do |ch, i|
                box = l.genConstBox(selfBox.w*i/n, 0,
                selfBox.w/n, selfBox.h*1, ch)
                bb = ch.layout(l, box)
                bbs << bb
                if(ch.layoutOpts.include? :weight)
                    weight_list << ch.layoutOpts[:weight]
                else
                    weight_list << 1.0
                end
            end
        end

        #print("classes = ")
        #puts(bbs.map{|b| b.info.class})
        #print("widths  = ")
        #puts(bbs.map{|b| b.w})
        #print("heights = ")
        #puts(bbs.map{|b| b.h})

        heights = Hash.new
        bbs.each do |b|
            tp = b.info.class == Qml::Knob ? :knob : :other
            heights[tp]  ||= b.h
            heights[tp]    = b.h if b.h < heights[tp]
        end
        #puts heights
        bbs.each do |b|
            tp = b.info.class == Qml::Knob ? :knob : :other
            b.y += (b.h-heights[tp])/2
            b.h  = heights[tp]
        end

        content_items = blist
    }

    function layout(l, selfBox)
    {
        contentBox = content.fixed(l, selfBox, 0, 0, 1, (1-lsize))
        labelBox   = labels.fixed(l,  selfBox, 0, (1-lsize), 1, lsize)

        content_items = layout_hpack(l, contentBox, row.content.children, :normal)
        label_items   = layout_hpack(l, labelBox,   row.labels.children,  :labels,
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
    function class_name() { "ParModuleRow" }

    Widget {
        id: content
        function class_name() { "ContentBox" }
    }
    Widget {
        id: labels
        function class_name() { "LabelBox" }
    }
}
