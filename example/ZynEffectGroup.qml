//Scrollable container for Zyn effects

//Vertically packs effects according to type
//each type is either 1U, 2U, or 3U and gets space accordingly
//either a whole effect can fit on the screen or a series of 1U
//placeholders are put in its place

Widget {
    id: egrp
    property Int   nunits: 6
    property Int   offset: 0
    property Hash  effects: Hash.new
    property Int   maxeffects: 8
    property Int   shownWeights: []
    property Array valueRef: nil
    property Bool  needsRegen: false

    function onSetup(old=nil)
    {
        v = []
        (0...maxeffects).each do |i|
            rf = extern + i.to_s + "/efftype"
            r  = OSC::RemoteParam.new($remote, rf)
            r.mode = :options
            r.callback = lambda {|x|
                lu = egrp.lookup(x)
                if(egrp.effects[i] != lu)
                    egrp.effects[i] = lu
                    egrp.needsRegen = true
                end
            }
            v << r
        end
        self.valueRef = v
        generate_children if(egrp.effects.length != 0)
    }

    function total_len()
    {
        total = 0
        (0...maxeffects).each do |r|
            if(effects.include?(r) && effects[r] != :none)
                lu = get_units(effects[r])
                total += lu
            else
                total += 1
            end
        end
        total
    }

    function translate_off(x)
    {
        total = 0
        (0..maxeffects).each do |r|
            if(effects.include?(r) && effects[r] != :none)
                lu = get_units(effects[r])
                total += lu
            else
                total += 1
            end
            return r if total > x
        end
        return maxeffects-1
    }

    function animate()
    {
        #Check for a new offset
        v = 1.0-children[0].value
        range = 1.0+total_len-self.nunits
        new_off = 0
        new_off = v*range if(range > 0)
        noff = translate_off(new_off)
        if(noff != self.offset)
            self.offset = noff
            self.needsRegen = true
        end

        regen_children if self.needsRegen
    }

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

    function regen_children()
    {
        self.needsRegen = false
        children[1..-1].each do |ch|
            rec_clean_cbs(ch)
            del_list = rec_del_props(ch)
            @db.remove_properties del_list
        end
        self.children = [self.children[0]]
        generate_children()
        if(root)
            root.smash_layout
            damage_self :all
        end
    }

    function setup_widget(w)
    {
        w.onSetup if w.respond_to?(:onSetup)
        w.children.each do |c|
            setup_widget c
        end
    }

    function generate_children()
    {
        return if children.length > 1
        w = []
        running = 0
        (0...self.nunits).each do |r|
            r += self.offset
            if(effects.include?(r) && effects[r] != :none)
                un = get_units(effects[r])
                if(running + un <= nunits)
                    col = make_child(effects[r])
                    col.extern = extern + r.to_s + "/"
                    Qml::add_child(self, col)
                    db.update_values
                    setup_widget(col)
                    w << un
                    running += un
                    next
                end
            end
            if(running < nunits)
                col = Qml::DummyBox.new(db)
                Qml::add_child(self, col)
                w << 1
                running += 1
            end
        end
        self.shownWeights = w
    }

    function make_child(type)
    {
        if(type == :reverb)
            return Qml::ZynReverb.new(db)
        elsif(type == :echo)
            return Qml::ZynEcho.new(db)
        elsif(type == :chorus)
            return Qml::ZynChorus.new(db)
        elsif(type == :distortion)
            return Qml::ZynDistortion.new(db)
        elsif(type == :alienwah)
            return Qml::ZynAlienwah.new(db)
        elsif(type == :phaser)
            return Qml::ZynPhaser.new(db)
        elsif(type == :eq)
            return Qml::ZynEqualizer.new(db)
        elsif(type == :dynamicfilter)
            return Qml::ZynDynFilter.new(db)
        else
            col = Qml::ColorBox.new(db)
            col.bg = color(:red)
            return col
        end
    }

    function lookup(type) {
        mapper = {0=>:none,
                  1=>:reverb,
                  2=>:echo,
                  3=>:chorus,
                  4=>:phaser,
                  5=>:alienwah,
                  6=>:distortion,
                  7=>:eq,
                  8=>:dynamicfilter}
        mapper[type]
    }

    function get_units(type)
    {
        mapper = {:alienwah => 1,
                  :chorus => 1,
                  :distortion => 2,
                  :dynamicfilter => 4,
                  :eq => 2,
                  :echo => 1,
                  :phaser => 2,
                  :reverb => 1}
        mapper[type]
    }

    function layout(l, selfBox)
    {
        children[0].fixed(l, selfBox, 0.98, 0, 0.02, 1)
        padw = 5
        padh = 3
        if(children.length > 1 && self.shownWeights.length > 0)
            off = 0
            children[1..-1].each_with_index do |ch, i|
                lh = shownWeights[i]
                ch.fixed_long(l, selfBox, 0, off/nunits, 0.98,
                  lh/nunits, padw, padh, -2*padw, -2*padh)
                off += lh
            end
        end
        selfBox
    }
    ScrollBar {}
}
