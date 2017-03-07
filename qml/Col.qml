Widget {
    id: col
    property Float spacer: 5

    function layout(l, selfBox) {
        #Create A list of boxes
        bbs = []
        begin
            n = children.length
            children.each_with_index do |ch, i|
                sh = selfBox.h-spacer*n
                box = l.genConstBox(0, selfBox.h*i/n,
                selfBox.w, sh/n, ch)
                bb = ch.layout(l, box)
                bbs << bb
            end
        end

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
            b.y  += (b.h-minheight)/2
            b.h   = minheight
            b.x   = 0
            b.w   = selfBox.w
        end

        #make longer lists compact
        if(bbs.length > 3)
            py = spacer
            bbs.each do |b|
                b.y  = py
                py  += b.h + spacer
            end
        end

        selfBox
    }

}
