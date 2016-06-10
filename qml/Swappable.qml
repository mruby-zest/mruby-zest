Widget {
    id: swappable
    property String content: nil
    property Callback whenSwapped: nil

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

    function rec_clean_cbs(widget)
    {
        if(widget.respond_to? :valueRef)
            v = widget.valueRef
            if(v.class == Array)
                v.each do |vv|
                    vv.clean
                end
            else
                v.clean if v.respond_to? :clean
            end
        end
        widget.children.each do |ch|
            rec_clean_cbs(ch)
        end
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
            rec_clean_cbs(children[0])
            del_list = rec_del_props(swappable.children[0])
            @db.remove_properties del_list

            root.damage_item(children[0], :all) if root
            self.children = []
        end
    }

    function setup_widget(w)
    {
        w.onSetup if w.respond_to?(:onSetup)
        w.children.each do |c|
            setup_widget c
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
        self.db.update_values
        setup_widget widget
        self.db.update_values

        if(root)
            root.smash_layout
            root.damage_item widget
        else
            puts "MISSING ROOT"
        end
        self.whenSwapped.call if self.whenSwapped
    }

    function onMerge(val)
    {
        self.content = val.content if(val.respond_to?(:content))
    }

    onContent: {
        srt = Time.new
        swappable.remove_old_child
        mid = Time.new
        swappable.create_new_child
        dne = Time.new
        puts("[INFO] Content chagned to #{swappable.content}")
        puts("[INFO] Content swap took #{dne-srt} (#{100*(mid-srt)/(dne-srt)}% remove) (#{100*(dne-mid)/(dne-srt)}% add)")
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
