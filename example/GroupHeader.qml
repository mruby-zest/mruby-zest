Widget {
    id: titleW

    property Function whenClick:    nil
    property Bool     toggleable:   false
    property Bool     copyable:     false

    function onMousePress(ev) {
        whenClick.call if whenClick
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
    }

    function layout(l, selfBox)
    {
        pack_misc(l, selfBox, children)
    }

    Text {
        id: title
        label: self.label
        align: :left
        textColor: Theme::TextModColor
        height: 0.8
    }

    function onSetup(old=nil)
    {
        return if children.length != 1
        if(self.toggleable)
            pb = Qml::PowButton.new(db)
            pb.extern = self.toggleable
            Qml::add_child(self, pb)
        end
        if(self.copyable)
            cb = Qml::CopyButton.new(db)
            pb = Qml::PasteButton.new(db)
            cb.extern = self.extern
            pb.extern = self.extern
            Qml::add_child(self, cb)
            Qml::add_child(self, pb)
        end
    }
}
