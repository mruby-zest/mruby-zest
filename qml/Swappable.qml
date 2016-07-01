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

    function onSetup(old=nil)
    {
        create_new_child
    }


    function create_new_child()
    {
        return if self.content.nil?
        return if !self.children.empty?

        t1=Time.new
        widget = swappable.content.new(swappable.db)
        t2=Time.new
        widget.x = 0
        widget.y = 0
        widget.w = self.w
        widget.h = self.h
        widget.extern = self.extern if !self.extern.empty?
        Qml::add_child(self, widget)
        t3=Time.new
        self.db.update_values
        t4=Time.new
        setup_widget widget
        self.db.update_values
        t5=Time.new

        if(root)
            root.smash_layout
            root.damage_item widget
        end
        self.whenSwapped.call if self.whenSwapped
        [t2-t1, t4-t3, t5-t4]
    }

    function onMerge(val)
    {
        self.content = val.content if(val.respond_to?(:content))
    }

    function force_update()
    {
        srt = Time.new
        swappable.remove_old_child
        #mid = Time.new
        d2 = swappable.create_new_child
        dne = Time.new
        tot = dne-srt
        #scl = 100/tot
        puts("[INFO] Content chagned to #{swappable.content} in #{1000*tot}ms")
        #puts("[INFO] Content swap took #{1000*tot}ms (#{(scl*(mid-srt)).to_i}% remove) (#{(scl*(dne-mid)).to_i}% add)")
        #puts("[INFO]                                 (#{(scl*d2[0]).to_i}% init) (#{(scl*d2[1]).to_i}% update) (#{(scl*d2[2]).to_i}% setup)")
    }

    onContent: {
        return if(!swappable.children.empty? && swappable.children[0].class == swappable.content)
        swappable.force_update
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
