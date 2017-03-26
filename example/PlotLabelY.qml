Widget {
    property Array labels: ["-1", "0", "1"]

    function get_width(vg, text)
    {
        scale = 100
        $vg.font_size scale
        bb = $vg.text_bounds(0, 0, text.upcase)


        vg.font_face("bold")
        return w*scale/bb
    }

    function draw(vg)
    {
        return if labels.class != Array
        best_height = h/(labels.length+1)
        xx = []
        labels.each do |l|
            tmp = get_width(vg, l)
            best_height = tmp if tmp < best_height
            xx << tmp
        end

        vg.font_size best_height
        labels.each_index do |i|
            if(i == 0)
                vg.text_align NVG::ALIGN_BOTTOM | NVG::ALIGN_LEFT
                vg.text(0, h, labels[0].upcase)
            elsif(i == labels.length-1)
                vg.text_align NVG::ALIGN_TOP | NVG::ALIGN_LEFT
                vg.text(0, 0, labels[i].upcase)
            else
                vg.text_align NVG::ALIGN_MIDDLE | NVG::ALIGN_LEFT
                vg.text(0, h*i/(labels.length-1), labels[i].upcase)
            end
        end
    }
}
