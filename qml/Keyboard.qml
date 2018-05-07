Widget {
    id: keyboard
    property Array  data: nil
    property Object valueRef: nil
    property Int    whiteKeys: 8*7-5
    property Float  fixpad: 1.5
    property Int    select_id: nil
    property Int    prev_note: nil

    property Float  velocity: 100
    property Float  velrnd: 0
    property Int    octave: 0

    //Widget hierarchy priority
    property Int    priority: 10

    function set_data(data_)
    {
        if(self.data != data_)
            self.data = data_
            self.damage_self
        end
    }

    function onSetup(old=nil)
    {
        self.valueRef = OSC::RemoteParam.new($remote, "/active_keys")
        self.valueRef.callback = lambda { |x| keyboard.set_data x }
    }

    function animate()
    {
        self.valueRef.refresh
    }

    function class_name() {"Keyboard"}

    function white_key_id(ind)
    {
        @@key_lookup ||= Hash.new
        return @@key_lookup[ind] if @@key_lookup.include?(ind)

        base = 9
        black_pattern = [1,0,1,1,0,1,1];

        off = 0

        black_pos = 0
        ind.times do
            black_pos = black_pos % black_pattern.length
            off += 1
            off += black_pattern[black_pos]
            black_pos += 1
        end

        @@key_lookup[ind] = base + off
        base + off
    }

    function get_note(pos)
    {
        rel = Pos.new(pos.x-global_x, pos.y-global_y)
        (0..whiteKeys).each do |i|
            bid = black_key_id(i)
            wid = white_key_id(i)
            bb  = black_bb(i, whiteKeys, false)
            wb  = white_bb(i, whiteKeys, false)
            if((i != whiteKeys) && (Rect.new(*bb).include? rel))
                return bid
            elsif(Rect.new(*wb).include? rel)
                return wid
            end
        end
        return nil
    }

    function get_note_name(note)
    {
        return "" if note.nil?
        note_names = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
        octave_num = note / 12 -1
        index = note % 12
        note_names[index] + octave_num.floor.to_s + " " + note.to_s
    }

    function onMousePress(ev)
    {
        note = get_note(ev.pos)
        self.prev_note = note
        self.root.log(:tooltip, get_note_name(note))
        noteOn(note)
    }

    function noteOn(note)
    {
        vel = velocity+(rand-0.5)*velrnd;
        vel = [0, [127, vel].min].max.to_i

        if(note && data && data[note])
            return
        end


        if(note && $remote)
            $remote.action("/noteOn", 0, note, vel)
        end
    }

    function onMouseMove(ev)
    {
        note = get_note(ev.pos)
        name = get_note_name(note)
        self.root.log(:tooltip, name)
        if(note != self.prev_note)
            $remote.action("/noteOff", 0, self.prev_note)
            noteOn(note)
            self.prev_note = note
        end
    }

    function onMouseHover(ev)
    {
        note = get_note(ev.pos)
        name = get_note_name(note)
        self.root.log(:tooltip, name)
    }

    function onMouseRelease(ev)
    {
        note = get_note(ev.pos)
        if(note && $remote)
            $remote.action("/noteOff", 0, note)
        end
    }
        //qwertz_high = ['q','2','w','3','e','r','5','t','6','z','7','u','i','9','o','0','p',252,"'",'+','\\']
        //qwertz_low  = ['y','s','x','d','c','v','g','b','h','n','j','m',',','l','.',246,'-']

        //azerty_high = ['a',233,'z','"','e','r','(','t','-','y',232,'u','i',231,'o',224,'p',65106,'=','$']#)
        //azerty_low  = ['w','s','x','d','c','v','g','b','h','n','j',',',';','l',':','m','!']
        //dvorak_high = "'2,3.p5y6f7gc9r0l/]=\\".to_a
        //dvorak_low  = ";oqejkixdbhmwnvsz".to_a
        

    function onKey(k, act)
    {
        qwerty_high = "q2w3er5t6y7ui9o0p[=]\\"
        qwerty_low  = "zsxdcvgbhnjm,l.;/"

        note = nil
        off = 0
        qwerty_low.each_char do |i|
            if(k==i)
                note = 60 - 12 + off + self.octave*12
                break
            end
            off += 1
        end

        off = 0
        qwerty_high.each_char do |i|
            if(k==i)
                note = 60 + off
                break
            end
            off += 1
        end

        return if note.nil?

        if(act == "press")
            noteOn(note)
            self.root.log(:tooltip, get_note_name(note))
        else
            $remote.action("/noteOff", 0, note)
        end

    }

    function black_key_id(ind)
    {
        white_key_id(ind) + 1
    }

    function no_black(i)
    {
        black_pattern = [1,0,1,1,0,1,1];
        black_pattern[i%7] == 0
    }

    function white_bb(i, white_keys, pad=true)
    {
        padh = fixpad/2
        box  = [i*w*1.0/(white_keys+1), padh, w*1.0/(white_keys+1), h-padh];
        if(pad)
            fixedpad(box, fixpad)
        else
            box
        end
    }

    function black_bb(i, white_keys, pad=true)
    {
        width = 0.65
        box = [(i+1.0-width/2)*w*1.0/(white_keys+1), 0,
               w*width/(white_keys+1), h*0.7];
        if(pad)
            fixedpad(box, fixpad)
        else
            box
        end
    }

    function draw_white(vg, i, white_keys)
    {
        white1       = Theme::KeyWhiteGrad1
        white2       = Theme::KeyWhiteGrad2
        white_accent = Theme::KeyWhiteAccent
        enable_color = Theme::KeyEnable

        box = white_bb(i, white_keys)
        wid = white_key_id i
        vg.path do |vg|
            vg.rect(*box)
            paint = vg.linear_gradient(0,0,0,h,white1, white2)
            vg.fill_paint paint
            vg.fill_color enable_color if data && data[wid]
            vg.fill_color enable_color if wid == select_id
            vg.stroke_color white_accent

            vg.fill
            vg.stroke_width fixpad
            vg.stroke
        end
    }

    function draw_black(vg, i, white_keys)
    {
        black_color  = Theme::KeyBlack
        black_accent = Theme::KeyBlackAccent
        enable_color = Theme::KeyEnable
        bg_color     = Theme::KeyBackground

        id = black_key_id i
        return if no_black i
        box = black_bb(i, white_keys)
        vg.path do |vg|
            vg.rect(*box)
            vg.fill_color black_color
            vg.fill_color enable_color if data && data[id]
            vg.fill_color enable_color if id == select_id
            vg.stroke_color bg_color
            vg.fill
            vg.stroke
        end
        id = black_key_id i
        return if no_black i

        box = black_bb(i, white_keys)
        vg.path do |vg|
            p = fixpad/2
            vg.move_to(box[0]       -p,p+box[1]+box[3])
            vg.line_to(box[0]+box[2]+p,p+box[1]+box[3])
            vg.stroke_color bg_color
            vg.stroke_width fixpad*2
            vg.stroke
        end
        vg.path do |vg|
            p = fixpad/2
            o = fixpad/4
            vg.move_to(box[0]       +p,box[1]+box[3]-o)
            vg.line_to(box[0]+box[2]-p,box[1]+box[3]-o)
            vg.stroke_color black_accent
            vg.stroke_width fixpad
            vg.stroke
        end
    }

    function draw(vg)
    {
        white_keys = 8*7-3;
        white_keys = self.whiteKeys;
        black_pattern = [1,0,1,1,0,1,1];

        bg_color     = Theme::KeyBackground
        background bg_color

        #draw the white keys 7 octaves + 2
        (0..white_keys).each do |i|
            draw_white(vg, i, white_keys)
        end

        #draw the black keys at the joints
        (0..white_keys-2).each do |i|
            draw_black(vg, i, white_keys)
        end
    }

}
