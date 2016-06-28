Widget {
    id: mod
    property Bool copyable: false;
    property Bool editable: false;
    property Function whenClick: nil
    property Float topSize: 0.1

    layoutOpts: [:horizontal]

    function class_name() { "Group" }

    function onMousePress(ev) {
        whenClick.call if whenClick
    }

    function onSetup(old=nil) {
        mch = mod.children
        cch = content.children
        if(mch.length > 2)
            cch = cch+mch[2..-1]
            mch = mch[0..1]
            content.children = cch
            mod.children     = mch
        else
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
        titleBox   = titleW.layout(l)

        #Constrain Content Box
        l.contains(selfBox,titleBox)
        l.contains(selfBox,contentBox)
        l.topOf(titleBox,contentBox)
        l.sheq([contentBox.h, selfBox.h], [1, -(1-topSize)], 0)
        l.sheq([contentBox.w, selfBox.w], [1, -1], 0)

        l.contains(selfBox, titleBox)
        l.sheq([titleBox.x],[1],0)
        l.sheq([titleBox.h, selfBox.h], [1, -topSize], 0)


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
        pos = [0, 0, mod.w, topSize*mod.h]
        vg.path do |v|
            border(pos[3]*0.01, pos);
            vg.rect(*pos);
            v.fill_color Theme::ModuleGrad2
            vg.fill
        end

        #upperspace = [pos[0]+pos[2]*2.0f/3.0f, pos[1], pos[2]/3.0f, pos[3]];
        #//upper.draw(upperspace);

        pos2 = [*pos]
        pos2[2] /= 3;
        pad((1-topSize), pos2);
        #drawLeftLabel(vg, str, SPLAT(pos2));



        innerspace = [0, mod.h*topSize, mod.w, mod.h*(1-topSize)];
        border(w*0.003, innerspace);
        #//paint the inner panel
        vg.path do |v|
            v.rect(*innerspace)
            paint = v.linear_gradient(0,innerspace[1],0,innerspace[3],
            Theme::ModuleGrad1, Theme::ModuleGrad2)
            v.fill_paint paint
            v.fill
        end

    }

    Widget {
        id: titleW

        function onMousePress(ev) {
            mod.whenClick.call if mod.whenClick
        }

        function class_name() { "TitleBox" }

        function layout(l)
        {
            selfBox = l.genBox :titleBox, titleW
            t  = title.layout(l)
            l.contains(selfBox,t)
            l.sheq([t.x, selfBox.w], [1, -0.02], 0)

            bc = button_c.layout(l)
            l.contains(selfBox,bc)

            bp = button_p.layout(l)
            l.contains(selfBox,bp)

            pp = power.layout(l)
            l.contains(selfBox,pp)
            l.aspect(pp, 1, 1)
            l.rightOf(t,bc)
            l.rightOf(bc,bp)
            l.rightOf(bp,pp)
            l.weak(bc.x)
            selfBox
        }

        Text {
            id: title
            label: mod.label
            align: :left
            textColor: Theme::TextModColor
            height: 0.8
        }

        PowButton {
            id: power
            extern: mod.extern;
        }

        CopyButton {
            extern: mod.extern;
            id: button_c
        }
        PasteButton {
            extern: mod.extern;
            id: button_p
        }
    }
    Widget {
        id: content

        function layout(l)
        {
            (0..100).print '&'
            selfBox = l.genBox :contentBox, self
            begin
                prev = nil
                n = self.children.length
                self.children.each do |ch|
                    ch_box = ch.layout(l)
                    #child.h = 1/n * parent.h
                    l.contains(selfBox, ch_box)
                    l.sheq([ch_box.h, selfBox.h], [1, -1.0/n], 0)
                    l.topOf(prev, ch_box) if prev
                    prev   = ch_box
                end
            end
            selfBox
        }

        function class_name() { "ContentBox" }
    }
}
