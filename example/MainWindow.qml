Widget {
    id: window
    function class_name() { "MainWindow" }

    //Layout window
    // l - layout engine
    // p - constraint solution from parent widget
    function layout(l, selfBox)
    {
        side.fixed(l,        selfBox, 0, 0.1, 0.1, 0.8)
        head1.fixed(l,       selfBox, 0, 0,   1.0, 0.1)
        sub1.fixed(l,        selfBox, 0, 0.9, 1.0, 0.1)
        main_widget.fixed(l, selfBox, 0.102, 0.1, 0.89, 0.80)

        #Layout overlay panel (e.g. file browser)
        if(children.length == 5)
            children[4].fixed(l, selfBox, 0, 0, 1, 1)
        end

        selfBox
    }

    function draw(vg)
    {
        vg.path do |v|
            v.rect(0, 0, w, h)
            paint = v.linear_gradient(0,0,0,h,
            Theme::WindowGrad1, Theme::WindowGrad2)
            v.fill_paint paint
            v.fill
        end
    }

    function set_content(type)
    {
        root.set_view_pos(:view, type)
        root.change_view
    }

    function valueRef()
    {
        puts "valueref cleanup..."
        return @refs
    }

    function onSetup(old=nil)
    {
        return if main_widget.content
        @info = Hash.new

        #Assume parts are active for testing purposes
        (0...16).each do |prt|
            (0...16).each do |kit|
                @info[[prt,kit,:add]] = true
                @info[[prt,kit,:sub]] = true
                @info[[prt,kit,:pad]] = true
            end
        end

        @refs = []
        (0...16).each do |prt|
            (0...16).each do |kit|
                add = OSC::RemoteParam.new($remote,
                    "/part#{prt}/kit#{kit}/Padenabled")
                sub = OSC::RemoteParam.new($remote,
                    "/part#{prt}/kit#{kit}/Psubenabled")
                pad = OSC::RemoteParam.new($remote,
                    "/part#{prt}/kit#{kit}/Ppadenabled")
                add.callback =
                    lambda {|x| window.info(prt,kit,:add,x)}
                sub.callback =
                    lambda {|x| window.info(prt,kit,:sub,x)}
                pad.callback =
                    lambda {|x| window.info(prt,kit,:pad,x)}
                @refs << add
                @refs << sub
                @refs << pad
            end
        end


        set_view()
    }

    function info(a,b,c,d)
    {
        @info[[a,b,c]] = d
    }

    function set_view()
    {
        prt  = root.get_view_pos(:part)
        kit  = root.get_view_pos(:kit)
        type = root.get_view_pos(:view)

        if(type == :add_synth && !@info[[prt,kit,:add]])
            root.set_view_pos(:view, :kits)
        elsif(type == :pad_synth && !@info[[prt,kit,:pad]])
            root.set_view_pos(:view, :kits)
        elsif(type == :sub_synth && !@info[[prt,kit,:sub]])
            root.set_view_pos(:view, :kits)
        end

        type = root.get_view_pos(:view)

        if(type == :add_synth)
            main_widget.extern  = "/part#{prt}/kit#{kit}/adpars/"
            main_widget.content = Qml::ZynAddSynth
        elsif(type == :pad_synth)
            main_widget.extern  = "/part#{prt}/kit#{kit}/padpars/"
            main_widget.content = Qml::ZynPadSynth
        elsif(type == :sub_synth)
            main_widget.extern  = "/part#{prt}/kit#{kit}/subpars/"
            main_widget.content = Qml::ZynSubSynth
        elsif(type == :part)
            main_widget.extern  = "/part#{prt}/"
            main_widget.content = Qml::ZynPart
        elsif(type == :kits)
            main_widget.extern  = "/part#{prt}/"
            main_widget.content = Qml::ZynKit
        elsif(type == :effects)
            main_widget.extern  = "/"
            main_widget.content = Qml::ZynEffects
        elsif(type == :midi_learn)
            main_widget.extern  = "/"
            main_widget.content = Qml::ZynMidiLearn
        elsif(type == :mixer)
            main_widget.extern  = "/"
            main_widget.content = Qml::ZynMixer
        elsif(type == :banks)
            main_widget.extern  = "/"
            main_widget.content = Qml::ZynBank
        elsif(type == :about)
            main_widget.extern  = "/"
            main_widget.content = Qml::ZynAbout
        else
            main_widget.content = Qml::Widget
        end
    }

    ZynSidebar  { id: side  }
    ZynHeader   { id: head1 }
    ZynFooter   { id: sub1  }
    Swappable { id: main_widget }
}
