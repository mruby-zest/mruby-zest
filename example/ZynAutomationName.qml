Widget {
    Text {
        label: "Ins 1 · Kit 1 · Add · Vce 1 · Vol"
        height: 1.0
    }

    function create_menu(options, xx)
    {

        n = options.length
        n = 1 if options.class != Array
        widget = DropDown.new(self.db)
        widget.w = self.w*0.2
        widget.h = self.h*n
        widget.x = xx
        widget.y = 0
        widget.layer = 2
        widget.options = options
        widget.callback = lambda { |v|
            #set_value_user(v)
        }
        widget.y = -self.h*(n-1) if(widget.h+global_y > window.h)
        widget.prime(root())

        Qml::add_child(self, widget)
        root.smash_draw_seq
        root.damage_item widget
    }

    function onMousePress(ev)
    {
        ps = (ev.pos.x-global_x)/w
        opts = []
        if(ps<0.2)
            (1..16).each do |i|
                opts << "Ins #{i}"
            end
        elsif(ps < 0.4)
            (1..16).each do |i|
                opts << "Kit #{i}"
            end
        elsif(ps < 0.6)
            opts << "ADD"
            opts << "PAD"
            opts << "SUB"
        elsif(ps < 0.8)
            (1..16).each do |i|
                opts << "VCE #{i}"
            end
        else
            opts << "Vol"
            opts << "Freq"
            opts << "Mod. Type"
        end
        create_menu(opts, ev.pos.x-global_x)
    }
}
