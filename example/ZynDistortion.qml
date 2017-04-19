Widget {
    id: dst
    //label: "distortion"
    //topSize: 0.2
    function refresh(x=nil) {
        x ||= dst
        x.children.each do |xx|
            xx.refresh() if xx.respond_to? :refresh
            dst.refresh(xx)
        end
    }
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
                whenValue: lambda {wave.refresh}
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
