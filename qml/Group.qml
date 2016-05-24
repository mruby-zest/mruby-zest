Widget {
    id: mod
    property Bool copyable: false;
    property Bool editable: false;
    property String extern: "";

    layoutOpts: [:horizontal]
    
    function class_name() { "Group" }

    onChildren: {
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
        puts "group layout?"
        selfBox = l.genBox :parmodule, mod
        contentBox = content.layout(l)
        titleBox   = titleW.layout(l)

        #Constrain Content Box
        l.contains(selfBox,titleBox)
        l.contains(selfBox,contentBox)
        l.topOf(titleBox,contentBox)
        l.sheq([contentBox.h, selfBox.h], [1, -0.8], 0)
        l.sheq([contentBox.w, selfBox.w], [1, -1], 0)

        l.contains(selfBox, titleBox)
        l.sheq([titleBox.x],[1],0)
        l.sheq([titleBox.h, selfBox.h], [1, -0.2], 0)


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
        border(w*0.003, innerspace);
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

        function layout(l)
        {
            (0..100).print '&'
            puts "content layout..."
            selfBox = l.genBox :contentBox, self
            begin
                prev = nil
                N = self.children.length
                self.children.each do |ch|
                    puts "layout child"
                    ch_box = ch.layout(l)
                    #child.h = 1/N * parent.h
                    l.contains(selfBox, ch_box)
                    l.sheq([ch_box.h, selfBox.h], [1, -1.0/N], 0)
                    l.topOf(prev, ch_box) if prev
                    prev   = ch_box
                end
            end
            selfBox
        }

        function class_name() { "ContentBox" }
    }
}
