Widget {
    id: swappable
    property String content: nil

    onContent: {
        puts "request to swap content"

        puts swappable.content
        puts swappable.content.nil?

        #it should only be possible that there is a single child
        if(!swappable.children.empty?)
            swappable.children = []
        end
        if(!swappable.content.nil?)
            widget = swappable.content.new(swappable.db)
            widget.w = swappable.w
            widget.h = swappable.h
            widget.x = 0
            widget.y = 0
            Qml::add_child(swappable, widget)
            if(swappable.root)
                swappable.root.smash_draw_seq
            end
        end
    }
}
