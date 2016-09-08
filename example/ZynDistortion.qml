Group {
    id: dst
    label: "distortion"
    topSize: 0.2
    function refresh() {
        return if rw.content.nil?
        return if rw.content.children.length < 4
        rw.content.children[3..-1].each do |c|
            c.refresh
        end
    }
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

        Selector {   extern: dst.extern + "Distorsion/Ptype"; }
        Knob {   extern: dst.extern + "Distorsion/Plrcross"; label: "l.rc." }
        Knob {   extern: dst.extern + "Distorsion/Pdrive"; label: "drive" }
        Knob {   extern: dst.extern + "Distorsion/Plevel"; label: "level" }
        Knob {   extern: dst.extern + "Distorsion/Plpf"}
        Knob {   extern: dst.extern + "Distorsion/Phpf"}
        ToggleButton { extern: dst.extern + "Distorsion/Pprefiltering"}
        ToggleButton { extern: dst.extern + "Distorsion/Pstereo"}
    }
}
