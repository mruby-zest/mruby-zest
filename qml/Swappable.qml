Widget {
    id: swappable
    property String content: nil

    function rec_del_props(widget, plist=[])
    {
        return plist if widget.nil?
        #Add all properties to the delete list
        widget.properties.each do |k,v|
            plist << v
        end
        #Add all children properties to the list
        widget.children.each do |ch|
            rec_del_props(ch, plist)
        end
        plist
    }

    function dump_plist()
    {
        plist = swappable.db.instance_eval{@plist}
        plist.each_with_index do |x, idx|
            if(idx<50)
                print idx
                print " "
                puts x.to_s
            end
        end
        puts plist.length
    }

    function remove_old_child()
    {
        #it should only be possible that there is a single child
        if(!self.children.empty?)
            del_list = rec_del_props(swappable.children[0])
            @db.remove_properties del_list
            self.children = []
        end
    }

    function create_new_child()
    {
        return if self.content.nil?

        widget = swappable.content.new(swappable.db)
        widget.x = 0
        widget.y = 0
        widget.w = self.w
        widget.h = self.h
        Qml::add_child(self, widget)

        if(root)
            root.smash_layout
            root.damage_item widget
        else
            puts "MISSING ROOT"
        end
        #puts "my children should just be :"
        #puts widget

    }

    onContent: {
        swappable.remove_old_child
        swappable.create_new_child
    }
    
    function layout(l)
    {
        #puts "swappable layout"
        #puts "swappable content is"
        #puts self.children[0].class
        t = self.class_name.to_sym
        selfBox = l.genBox t, widget
        self.children.each do |child|
            if(child.respond_to?(:layout))
                box = child.layout(l)
                l.contains(selfBox, box)
            end
        end
        selfBox
    }
}
