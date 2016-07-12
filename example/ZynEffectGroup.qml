//Scrollable container for Zyn effects

//Vertically packs effects according to type
//each type is either 1U, 2U, or 3U and gets space accordingly
//either a whole effect can fit on the screen or a series of 1U
//placeholders are put in its place

Widget {
    property Int   nunits: 6
    property Int   offset: 0
    property Hash  effects: {}
    property Int   maxeffects: 8
    property Int   shownWeights: []

    function onSetup(old=nil)
    {
        return if children.length > 1
        puts "look at me"
        w = []
        running = 0
        (0...6).each do |r|
            if(effects.include?(r))
                puts effects
                un = get_units(effects[r])
                puts un
                if(running + un <= nunits)
                    col = Qml::ColorBox.new(db)
                    col.bg = color(:red)
                    Qml::add_child(self, col)
                    w << un
                    running += un
                    next
                end
            end
            if(running < nunits)
                col = Qml::ColorBox.new(db)
                col.bg = color(:blue)
                Qml::add_child(self, col)
                w << 1
                running += 1
            end
        end
        self.shownWeights = w
    }

    function generate_children()
    {
    }

    function get_units(type)
    {
        mapper = {:alienwah => 1,
                  :chorus => 1,
                  :distortion => 1,
                  :dynamicfilter => 3,
                  :eq => 2,
                  :echo => 1,
                  :phaser => 1,
                  :reverb => 1}
        mapper[type]
    }

    function layout(l)
    {
        selfBox = l.genBox :eff, self
        scroll  = children[0].layout(l)
        padw = 5
        padh = 3
        l.fixed(scroll, selfBox, 0.98, 0, 0.02, 1)
        if(children.length > 1 && self.shownWeights.length > 0)
            off = 0
            children[1..-1].each_with_index do |ch, i|
                bx = ch.layout(l)
                lh = shownWeights[i]
                l.fixed_long(bx, selfBox, 0, off/nunits, 0.98,
                  lh/nunits, padw, padh, -2*padw, -2*padh)
                off += lh
            end
        end
        selfBox
    }
    ScrollBar {}
}
