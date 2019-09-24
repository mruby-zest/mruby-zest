Widget {
    id: mod
    property Bool copyable: true;
    property Bool toggleable: false;
    property Bool editable: false;
    property Function whenClick: nil
    property Float topSize: 0
    property Float pxpad: 8.0

    layoutOpts: [:horizontal]

    function class_name() { "Group" }

    function onMousePress(ev) {
        whenClick.call if whenClick
    }

    onToggleable: {
        return if(mod.copyable && titleW.children.length < 2)
        if(mod.toggleable && titleW.children[1].class != Qml::PowButton)
            pb = Qml::PowButton.new(mod.db)
            pb.extern = mod.toggleable
            pb.parent = titleW
            ch = titleW.children
            ch.insert(1, pb)
            titleW.children = ch
        end
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
        content.children.each do |ch|
            ch.parent = content
        end
    }

    //1. This widget forms a bounding box
    //2. The children of this widget exist
    //   within the bounding box
    //3. The children are packed horizontally
    function layout(l, selfBox)
    {
        titleW.fixed(l,   selfBox, 0, 0,       1, topSize)
        content.fixed_long(l, selfBox, 0, topSize, 1, 1-topSize, pxpad, pxpad, -2*pxpad, -2*pxpad)

        selfBox
    }

    function draw(vg)
    {
        vg.path do |v|
            v.rect(0, 0, mod.w, mod.h)
            v.fill_color(color("000000"))
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

        function pack_misc(l, selfBox, ch)
        {
            #Create A list of boxes
            bbs = []
            n = children.length
            children.each_with_index do |ch, i|
                box = l.genConstBox(selfBox.w*i/n, 0,
                selfBox.w/n, selfBox.h, ch)
                bb = ch.layout(l, box)
                bbs << bb
            end

            bbs[0].x = 15 if bbs[0].x > 15

            #put stuff on backwards
            bx = selfBox.w
            bbs[1..-1].reverse.each do |b|
                b.x  = bx-b.w
                bx  -= b.w
            end

            return selfBox

            minheight = 99999
            widths = Hash.new
            bbs.each do |b|
                tp = b.info.class == Qml::Knob ? :knob : :other
                minheight     = b.h if b.h < minheight
                widths[tp]  ||= b.w
                widths[tp]    = b.w if b.w < widths[tp]
            end
            bbs.each do |b|
                tp = b.info.class == Qml::Knob ? :knob : :other
                #b.y += (b.h-widths[tp])/2
                b.y  += (b.h-minheight)/2
                b.h   = minheight
                b.x   = 0
                b.w   = selfBox.w
            end
            selfBox
            return
            prev = ch[0]
            ch[1..-1].each_with_index do |c,i|
                l.contains(selfBox, c)
                l.rightOf(prev,c)
                l.aspect(c, 1, 1) if children[i+1].class == Qml::PowButton
                prev = c
            end
            l.weak(ch[1].x) if ch.length > 1
            selfBox
        }

        function layout(l, selfBox)
        {
            #return selfBox if children.length == 1
            pack_misc(l, selfBox, children)
        }

        Text {
            id: title
            label: mod.label
            align: :left
            textColor: Theme::TextModColor
            height: 0.8
        }
    }
    Widget {
        id: content

        function layout(l, selfBox) {
            Draw::Layout::vpack(l, selfBox, children)
        }

        function class_name() { "ContentBox" }
    }
}
