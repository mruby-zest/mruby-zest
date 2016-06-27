Widget {
    id: keyboard
    property Array data: nil
    property Object valueRef: nil

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

        base + off
    }

    function black_key_id(ind)
    {
        white_key_id(ind) + 1
    }

    function draw(vg)
    {
        white_keys = 8*7-3;
        black_pattern = [1,0,1,1,0,1,1];

        white1       = Theme::KeyWhiteGrad1
        white2       = Theme::KeyWhiteGrad2
        white_accent = Theme::KeyWhiteAccent
        black_color  = Theme::KeyBlack
        black_accent = Theme::KeyBlackAccent
        enable_color = Theme::KeyEnable

        #//draw the white keys 7 octaves + 2
        (0..white_keys).each do |i|
            box = [i*w*1.0/(white_keys-1), 0, w*1.0/(white_keys), h];
            pad(0.8, box);
            vg.path do |vg|
                vg.rect(*box)
                paint = vg.linear_gradient(0,0,0,h,white1, white2)
                vg.fill_paint paint
                vg.fill_color enable_color if data && data[white_key_id i]
                vg.stroke_color white_accent

                vg.fill
                vg.stroke_width 1.2
                vg.stroke
            end
        end

        #//draw the black keys at the joints
        (0..white_keys).each do |i|
            id = black_key_id i
            if(black_pattern[i%7] == 0)
                next;
            end
            box = [(i+0.55)*w*1.0/(white_keys-1), 0, w*0.8/(white_keys), h*0.7];
            pad(0.8, box);
            vg.path do |vg|
                vg.rect(*box)
                vg.fill_color black_color
                vg.fill_color enable_color if data && data[id]
                vg.fill
            end
        end
        #//draw the black keys at the joints
        (0..white_keys).each do |i|
            id = black_key_id i
            if(black_pattern[i%7] == 0)
                next;
            end
            box = [(i+0.55)*w*1.0/(white_keys-1), 0, w*0.8/(white_keys), h*0.7];
            pad(0.8, box);
            vg.path do |vg|
                vg.move_to(box[0],box[1]+box[3])
                vg.line_to(box[0]+box[2],box[1]+box[3])
                vg.stroke_color black_accent
                vg.stroke_width 2.0
                vg.stroke
            end
        end
    }

}
