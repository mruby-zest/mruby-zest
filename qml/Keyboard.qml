Widget {
    id: keyboard

    function class_name() {"Keyboard"}
    function draw(vg)
    {
        white_keys = 8*7-3;
        black_pattern = [1,0,1,1,0,1,1];

        white_color = color("9AA1A8")
        black_color = color("2A353F")

        #//draw the white keys 7 octaves + 2
        (0..white_keys).each do |i|
            box = [i*w*1.0/(white_keys-1), 0, w*1.0/(white_keys), h];
            pad(0.9, box);
            vg.path do |vg|
                vg.rect(*box)
                vg.fill_color white_color
                vg.fill
            end
        end

        #//draw the black keys at the joints
        (0..white_keys).each do |i|
            if(black_pattern[i%7] == 0)
                next;
            end
            box = [(i+0.55)*w*1.0/(white_keys-1), 0, w*0.8/(white_keys), h*0.7];
            pad(0.9, box);
            vg.path do |vg|
                vg.rect(*box)
                vg.fill_color black_color
                vg.fill
            end
        end
    }

}
