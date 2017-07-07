Widget {
    ZynWipTwo {}

    function layout(l, selfBox)
    {
        children[0].fixed(l,        selfBox, 0.05, 0.05, 0.95, 0.85)
    }

    function draw(vg)
    {
        draw2(vg)
    }

    function draw2(vg)
    {
        vg.text_align NVG::ALIGN_MIDDLE | NVG::ALIGN_CENTER
        vg.font_size 30.0
        vg.fill_color color("ffffff")
        vg.text(550, 10, "Format Vowel (Live?) View [radius=1/q]")
        vg.text(20, 470, "-10 dB")
        vg.text(20, 300, "-5 dB")
        vg.text(20, 100, "0 dB")
        vg.text(20, 10, "10 dB")
        
        vg.text(150, 500, "10 Hz")
        vg.text(550, 500, "100 Hz")
        vg.text(950, 500, "1 kHz")

    }
    function draw1(vg)
    {
        vg.text_align NVG::ALIGN_MIDDLE | NVG::ALIGN_CENTER
        vg.font_size 30.0
        vg.fill_color color("ffffff")
        vg.text(550, 10, "Format Sequence View")
        vg.text(20, 470, "0 Hz")
        vg.text(20, 300, "100 Hz")
        vg.text(20, 100, "1k Hz")
        vg.text(20, 10, "10k Hz")
        
        vg.text(150, 500, "Seq Pos 1")
        vg.text(550, 500, "Seq Pos 2")
        vg.text(950, 500, "Seq Pos 3")

    }
}
