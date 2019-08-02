
Widget{
    function layout(l, selfBox) {
        Draw::Layout::vfill(l, selfBox, children, [0.55, 0.4, 0.05])
    }
    ZynOscilloscope{
        options: ["PadNote", "PadNote1"]
        opt_vals: ["/part0/kit0/padpars/noteout","/part0/kit0/padpars/noteout1"] 
    }


    Widget {
        id: row2
        function layout(l, selfBox) {
            Draw::Layout::hpack(l, selfBox, children)
        }
        Swappable { id: amp_gen }
        Swappable { id: amp_env }
        Swappable { id: amp_lfo }
    }

   function set_oscill(base)
    {   
        amp_gen.extern  = base
        amp_env.extern  = base + "AmpEnvelope/"
        amp_lfo.extern  = base + "AmpLfo/"
        amp_gen.content = Qml::ZynPadAmp
        amp_env.content = Qml::ZynAmpEnv
        amp_lfo.content = Qml::ZynLFO
    }


    function onSetup(old=nil)
    {
       set_oscill("/part0/kit0/padpars/")
    }
}