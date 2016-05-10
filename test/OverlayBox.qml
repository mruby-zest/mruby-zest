Widget {
    id: overlaybox

    function draw(vg)
    {
        vg.path do |v|
            v.rect(0,0,w,h)
            v.fill_color(NVG.rgba(0xff,0xff,0xff,0x80))
            v.fill
        end
        vg.path do |v|
            v.move_to(0,0)
            v.line_to(w,h)
            v.move_to(w,0)
            v.line_to(0,h)
            v.stroke_color(NVG.rgba(0xff,0xff,0xff,0xff))
            v.stroke
        end
    }
    
    function onMousePress(ev) {
        puts "I got a mouse press (overlaybox)"
        rt = overlaybox.root
        rt.ego_death overlaybox
        #puts test.root
        #if(children.empty?)
        #    widget = OverlayBox.new(test.db)
        #    widget.w = test.w
        #    widget.h = test.h
        #    widget.x = 0
        #    widget.y = 0
        #    Qml::add_child(test, widget)
        #end
        #test.root.damage_item(test)
    }
}
