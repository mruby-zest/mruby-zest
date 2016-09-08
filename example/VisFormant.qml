Widget {
    id: vfor
    property Object valueRef: nil
    property Object numformants: 4
    property Object q_value: 1
    property Object stages: 1
    property Object gain_value: 1.0
    property Array  vowels: nil
    property Bool   pending_damage: false
    property Bool   refreshing: false
    property Int    vowel_num: 0

    function change() {
        #puts "[DEBUG] Pending Change"
        self.pending_damage = true
    }

    function refresh() {
        self.refreshing = true
    }

    function onSetup(old=nil) {
        #puts "[DEBUG] Formant Graph"
        base = vfor.extern
        #puts "[DEBUG] extern root is <#{base}>"
        refs = []

        #Vowel data
        val = OSC::RemoteParam.new($remote, base+"vowels")
        val.callback = lambda {|x|
            nvowels   = x[0]
            nformants = x[1]
            vs = []
            (0...nvowels).each do |vv|
                v = []
                (0...nformants).each do |f|
                    ind = 2 + 3*nformants*vv + 3*f
                    v << Formant.new(x[ind+0], x[ind+1], x[ind+2])
                end
                vs << v
            end
            vfor.vowels = vs;
            vfor.change
        }
        refs << val

        #num formants
        val = OSC::RemoteParam.new($remote, base+"Pnumformants")
        val.mode = :full
        val.callback = lambda {|x|
            vfor.numformants = x
            vfor.change
        }
        refs << val

        #q
        val = OSC::RemoteParam.new($remote, base+"q_value")
        val.callback = lambda {|x|
            vfor.q_value = x
            vfor.change
        }
        refs << val

        #stages
        val = OSC::RemoteParam.new($remote, base+"Pstages")
        val.callback = lambda {|x|
            vfor.stages = x + 1
            vfor.change
        }
        refs << val

        #gain
        val = OSC::RemoteParam.new($remote, base+"Pgain")
        val.callback = lambda {|x|
            vfor.gain_value = x
            vfor.change
        }
        refs << val
        self.valueRef = refs
    }

    function draw(vg)
    {
        padfactor = 10
        bb = Draw::indent(Rect.new(0,0,w,h), padfactor, padfactor)
        background Theme::VisualBackground
        Draw::Grid::log_x(vg, 1, 20000, bb)
        Draw::Grid::linear_y(vg, 1, 20, bb)
    }

    function animate()
    {
        if(self.refreshing)
            self.refreshing = false
            valueRef.each do |r|
                r.refresh()
            end
        end
        if(self.pending_damage)
            self.pending_damage = false
            #puts "numfor= #{self.numformants}"
            #puts "q_valu= #{self.q_value}"
            #puts "stages= #{self.stages}"
            #puts "gain  = #{self.gain_value}"
            #puts "vowels= #{self.vowels}"
            response(self.vowel_num) if !self.vowels.nil?
        end
    }

    function response(nvowel)
    {
        xpts = Draw::DSP::logspace(1, 20000, 256)
        vo   = self.vowels[nvowel]
        return if vo.nil?
        fo   = vo
        fo   = fo[0...numformants] if numformants <= fo.length
        ypts = formant_filter_response(xpts, fo, q_value, stages,
               gain_value)
        data_view.data = ypts
        data_view.damage_self
        damage_self
    }

    DataView {
        id: data_view
        normal: true
        pad: 0
        fixedpad: 5
    }
}
