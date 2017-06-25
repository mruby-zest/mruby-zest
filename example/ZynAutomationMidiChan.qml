TextBox {
    id: midi_chan
    onExtern: {
        ext  = midi_chan.extern

        learn_ref = OSC::RemoteParam.new($remote, ext + "learning")
        midi_ref  = OSC::RemoteParam.new($remote, ext + "midi-cc")

        midi_ref.mode  = true
        learn_ref.mode = true

        learn_ref.callback = lambda {|x| midi_chan.learning = x; update_text()}
        midi_ref.callback  = lambda {|x| midi_chan.cc = x;       update_text()}


        midi_chan.valueRef = [learn_ref, midi_ref]
    }

    function update_text() {
        @cc = nil       if(@cc.nil?       || @cc < 0)
        @learning = nil if(@learning.nil? || @learning < 0)

        new_label = self.label;
        if(@cc && !@learning)
            new_label = "MIDI CC #{@cc}"
        elsif(!@cc && @learning)
            new_label = "Learning Queue #{@learning}"
        elsif(@cc && @learning)
            new_label = "MIDI CC #{@cc} - Relearning Queue #{@learning}"
        else
            new_label = "Unbound"
        end

        if(new_label != self.label)
            self.label = new_label
            damage_self
        end
    }

    function onSetup(old=nil) {
        @cc       = nil
        @learning = nil
    }

    function cc=(x)       {@cc = x}
    function learning=(x) {@learning = x}

}
