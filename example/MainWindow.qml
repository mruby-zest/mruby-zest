Widget {
    id: window
    function class_name() { "MainWindow" }

    function layout(l)
    {
        t = widget.class_name.to_sym
        selfBox = l.genBox t, widget
        chBox   = main_widget.layout(l)
        sideBox = side.layout(l)
        headBox = head1.layout(l)
        footBox = sub1.layout(l)

        l.fixed(chBox, selfBox, 0.102, 0.1, 0.89, 0.80)
        l.fixed(sideBox, selfBox, 0, 0.1, 0.1, 0.8)
        l.fixed(headBox, selfBox, 0, 0,   1.0, 0.1)
        l.fixed(footBox, selfBox, 0, 0.9, 1.0, 0.1)

        selfBox
    }

    function draw(vg)
    {
       vg.path do |v|
           v.rect(0, 0, w, h)
           v.fill_color color("353B44")
           v.fill
       end
    }

    function set_content(type, offset=0)
    {
        puts "top window set content"
        puts type
        if(type == :add_synth)
            main_widget.content = Qml::ZynAddSynth
        elsif(type == :pad_synth)
            main_widget.content = Qml::ZynPadHarmonics
        elsif(type == :sub_synth)
            main_widget.content = Qml::ZynSubSynth
        elsif(type == :part)
            main_widget.content = Qml::ZynPart
        elsif(type == :kits)
            main_widget.content = Qml::ZynKit
        elsif(type == :effects)
            main_widget.content = Qml::ZynEffects
        elsif(type == :midi_learn)
            main_widget.content = Qml::ZynMidiLearn
        elsif(type == :mixer)
            main_widget.content = Qml::ZynMixer
        elsif(type == :banks)
            main_widget.content = Qml::ZynBank
        else
            main_widget.content = Qml::Widget
        end
    }

    ZynSidebar  { id: side  }
    ZynHeader   { id: head1 }
    ZynFooter   { id: sub1  }
    Swappable {
        id: main_widget
        content: Qml::ZynAddSynth
    }
}
