Widget {
    id: mod
    property Bool copyable: false;
    property Bool editable: false;

    layoutOpts: [:horizontal]

    onChildren: {
        mch = mod.children
        cch = content.children
        if(mch.length > 3)
            cch = cch+mch[3..-1]
            mch = mch[0..2]
            content.children = cch
            mod.children     = mch
        else
        end
    }

    function onSetup(old=nil) {
        n = content.children.length
        (0...n).each do |i|
            label = createInstance("Text", labels, mod.db)
            if(content.children[i].class_name != "Button")
                label.label = content.children[i].label
            end
        end
    }


    //1. This widget forms a bounding box
    //2. The children of this widget exist
    //   within the bounding box
    //3. The children are packed horizontally
    function layout(l)
    {
        selfBox = l.genBox :parmodule, mod
        contentBox = content.layout(l)
        labelsBox  = labels.layout(l)
        titleBox   = titleW.layout(l)

        #Constrain Content Box
        l.contains(selfBox,titleBox)
        l.contains(selfBox,contentBox)
        l.contains(selfBox,labelsBox)
        l.topOf(titleBox,contentBox)
        l.topOf(contentBox,labelsBox)
        l.sheq([contentBox.h, selfBox.h], [1, -0.5], 0)
        l.sheq([contentBox.w, selfBox.w], [1, -1], 0)
        l.sheq([labelsBox.h, selfBox.h],  [1, -0.3], 0)
        l.sheq([labelsBox.w, selfBox.w],  [1, -1], 0)

        l.contains(selfBox, titleBox)
        l.sheq([titleBox.x],[1],0)
        l.sheq([titleBox.h, selfBox.h], [1, -0.2], 0)


        prev = nil
        blist = []
        mod.content.children.each do |ch|
            bb = ch.layout(l)
            if(bb)
                blist << bb
                l.contains(contentBox, bb)
                #l.le([bb.y, selfBox.h], [-1, 0.2])
                if(prev)
                    l.rightOf(prev,bb, true)
                end
                prev = bb
            end
        end

        #Punish Different Sizes
        blist.each do |x|
            l.punish2([selfBox.w], [1.0/blist.length], x.w)
        end
        
        #Punish floating in the y dir
        blist.each do |x|
            l.weak(x.y)
        end

        #Center Stuff Horizontally
        if(!blist.empty?)
            l.sheq([blist[0].x, selfBox.w, blist[-1].x, blist[-1].w],
            [1,       -1,       1,     1], 0)
        end
        breal = blist

        content_items = blist

        prev = nil
        blist = []
        lh    = l.gensym :modlabelHeight
        mod.labels.children.each do |ch|
            bb = ch.layout(l)
            if(bb)
                blist << bb
                l.contains(labelsBox, bb)
                l.sheq([lh, bb.h], [1, -1], 0)
                if(prev)
                    l.rightOf(prev,bb, true)
                end
                prev = bb
            end
        end

        #Punish Different Sizes
        blist.each do |x|
            l.punish2([selfBox.w], [1.0/blist.length], x.w)
        end

        #Center Stuff Horizontally
        if(!blist.empty?)
            l.sheq([blist[0].x, selfBox.w, blist[-1].x, blist[-1].w],
            [1,       -1,       1,     1], 0)
        end

        #Stitch labels
        n = blist.length
        (1...n).each do |i|
            l.rightOf(breal[i-1],blist[i])
        end

        label_items = blist

        #Center labels
        if(label_items.length == content_items.length && true)
            (1...N).each do |i|
                li = label_items[i]
                ci = content_items[i]
                l.sheq([li.x, li.w, ci.x, ci.w],
                       [1, 0.5, -1, -0.5], 0)
            end
        end



        #Layout Custom Stuff
        #buttonBox = button.layout(l)
        #l.contains(titleBox,buttonBox)

        #blist.each_with_index do |x, i|
        #    blist.each_with_index do |y, j|
        #        if(i!=j)
        #            l.punish_difference(x.w,y.w)
        #        end
        #    end
        #end
        selfBox
    }

    function draw(vg)
    {
        vg.path do |v|
            v.rect(0, 0, mod.w, mod.h)
            v.fill_color(NVG.rgba(0,0,0,255))
            v.fill
        end
        #//paint the top half
        pos = [0, 0, mod.w, mod.h]
        pos[3] *= 0.2;
        vg.path do |v|
            border(pos[3]*0.01, pos);
            vg.rect(*pos);
            vg.fill_color(NVG.rgba(0xa, 0x2e, 0x4c, 255))
            vg.fill
        end

        #upperspace = [pos[0]+pos[2]*2.0f/3.0f, pos[1], pos[2]/3.0f, pos[3]];
        #//upper.draw(upperspace);

        pos2 = [*pos]
        pos2[2] /= 3;
        pad(0.9, pos2);
        #drawLeftLabel(vg, str, SPLAT(pos2));



        innerspace = [0, mod.h*0.2, mod.w, mod.h*0.8];
        border(h*0.01, innerspace);
        #//paint the inner panel
        vg.path do |v|
            v.rect(*innerspace)
            v.fill_color(NVG.rgba(0x6, 0x27, 0x37, 255))
            v.fill
        end

    }

    Widget {
        id: titleW

        function class_name() { "TitleBox" }

        function layout(l)
        {
            selfBox = l.genBox :titleBox, titleW
            t  = title.layout(l)
            l.contains(selfBox,t)

            bc = button_c.layout(l)
            l.contains(selfBox,bc)

            bp = button_p.layout(l)
            l.contains(selfBox,bp)
            l.rightOf(t,bc)
            l.rightOf(bc,bp)
            l.weak(bc.x)
            selfBox
        }

        Text {
            id: title
            label: mod.label
        }

        Button {
            //square
            function layout(l)
            {
                selfBox = l.genBox :copyButton, button_c
                l.aspect(selfBox, 1, 1)
                selfBox
            }
            id: button_c
            label: "C"
        }
        Button {
            function layout(l)
            {
                selfBox = l.genBox :copyButton, button_p
                l.aspect(selfBox, 1, 1)
                selfBox
            }
            id: button_p
            label: "P"
        }
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
