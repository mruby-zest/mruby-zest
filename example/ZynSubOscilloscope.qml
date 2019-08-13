Widget{
  function layout(l, selfBox) {
        Draw::Layout::vfill(l, selfBox, children, [0.55, 0.4, 0.05])
    }

    ZynOscilloscope{
        options: ["SubNote", "subNote1"]
        opt_vals: ["/part0/kit0/subpars/noteout","/part0/kit0/subpars/noteout1"] 
    }
    Widget 
    {
        id: row2
        function layout(l, selfBox) {
            Draw::Layout::hpack(l, selfBox, children)
        }


        Swappable { id: gen }
        Swappable { id: env }
    }

   function set_oscill(base)
    {   
        gen.extern  = base + "GlobalFilter/"
        env.extern  = base + "GlobalFilterEnvelope/"
        gen.content = Qml::ZynAnalogFilter
        env.content = Qml::ZynFilterEnv
        
    }

    function onSetup(old=nil)
    {
       set_oscill("/part0/kit0/subpars/")
    }

}

