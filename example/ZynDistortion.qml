Widget {
    id: dst
    //label: "distortion"
    //topSize: 0.2
    function refresh_recur(x) {
        #@@recur_level ||= 0
        #@@recur_level += 1
        #print " "*@@recur_level
        #puts "Distort refresh = {#{x.class}} of {#{dst.class}}"
        x.children.each do |xx|
            #print " "*(@@recur_level+1)
            #puts "child = #{xx.class}"
            xx.refresh() if xx.respond_to? :refresh
            dst.refresh_recur(xx)
        end
        #@@recur_level -= 1
    }
    function refresh() {
        refresh_recur(self)
    }
    GroupHeader {
        label: "Distortion"
        extern: dst.extern
        copyable: true
    }
    Widget {
        WaveView {
            id: wave
            extern: dst.extern + "Distorsion/waveform"
        }
        Widget {
            ParModuleRow {
                id: rw
                layoutOpts: []

                Selector {
                    extern: dst.extern + "Distorsion/preset"
                    whenValue: lambda { dst.refresh }
                    layoutOpts: [:long_mode]
                }
                Knob { extern: dst.extern + "Pvolume"}
                Knob { extern: dst.extern + "Ppanning"}
                Knob {   extern: dst.extern + "Distorsion/Plrcross"; label: "l.rc." }
                Knob {   extern: dst.extern + "Distorsion/Plpf"}
                Knob {   extern: dst.extern + "Distorsion/Phpf"}

            }
            ParModuleRow {
                id: rw2
                layoutOpts: []
                Selector {
                    extern: dst.extern + "Distorsion/Ptype";
                    whenValue: lambda {wave.refresh}
                    layoutOpts: [:long_mode]
                }
                Knob {
                    extern: dst.extern + "Distorsion/Pdrive"; label: "drive"
                                        whenValue: lambda {wave.refresh};
                    function setValue(v) {
                        valuator.value = lim(v, 0.0, 1.0);
                        valuator.whenValue.call;
                        valuator.damage_self
                    }
                }
                Knob {
                    extern: dst.extern + "Distorsion/Poffset"; label: "DC"
                    whenValue: lambda {wave.refresh};
                    function setValue(v) {
                        valuator.value = lim(v, 0.0, 1.0);
                        valuator.whenValue.call;
                        valuator.damage_self
                    }
                }
                Knob {
                    extern: dst.extern + "Distorsion/Pfuncpar"; label: "shape"
                    whenValue: lambda {wave.refresh};
                    function setValue(v) {
                        valuator.value = lim(v, 0.0, 1.0);
                        valuator.whenValue.call;
                        valuator.damage_self
                    }
                Knob {   extern: dst.extern + "Distorsion/Plevel"; label: "level" }
                Col {
                    ToggleButton { extern: dst.extern + "Distorsion/Pprefiltering"}
                    ToggleButton { extern: dst.extern + "Distorsion/Pstereo"}
                }
            }
            function layout(l, selfBox) {
                Draw::Layout::vpack(l, selfBox, children)
            }
        }

        function layout(l, selfBox) {
            Draw::Layout::hpack(l, selfBox, children)
        }
    }
    function layout(l, selfBox) {
        Draw::Layout::vfill(l, selfBox, children, [0.15, 0.85])
    }
}
