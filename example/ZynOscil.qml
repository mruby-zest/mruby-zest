Widget {
    extern: "/part0/kit0/adpars/VoicePar0/OscilSmp/"
    id: base_osc

    function refresh()
    {
        base.refresh
        full.refresh
        base_harm.refresh
        full_harm.refresh
    }

    TitleBar {
        id: base_title
        label: "base waveform"
    }

    HarmonicView {
        id: base_harm
        extern: base_osc.extern + "base-spectrum"
    }

    WaveView {
        id: base
        extern: base_osc.extern + "base-waveform"
    }

    TitleBar {
        id: full_title
        label: "full oscillator"
    }

    HarmonicView {
        id: full_harm
        extern: base_osc.extern + "spectrum"
    }

    WaveView {
        id: full
        extern: base_osc.extern + "waveform"
    }

    HarmonicEdit {
        extern: base_osc.extern
        whenValue: lambda {base_osc.refresh}
        id: hedit
    }

    ScrollBar {
        id: scroll
        vertical: false
    }

    Button {
        id: voice_button
        layoutOpts: [:no_constraint]
        label: "voice"
    }

    Button {
        id: mod_button
        layoutOpts: [:no_constraint]
        label: "mod"
    }

    Widget {
        id: middle_panel

        Widget {
            //COL 1
            //base
            TextBox { label: "base func."}
            Selector { whenValue: lambda {base_osc.refresh}; extern: base_osc.extern + "Pcurrentbasefunc"}
            HSlider  { whenValue: lambda {base_osc.refresh}; extern: base_osc.extern + "Pbasefuncpar"}
            Widget {}

            //modulation
            TextBox { label: "BF mod."}
            Selector { whenValue: lambda {base_osc.refresh}; id: modsel; extern: base_osc.extern + "Pbasefuncmodulation"}
            HSlider  { whenValue: lambda {base_osc.refresh}; extern: modsel.extern + "par1"}
            HSlider  { whenValue: lambda {base_osc.refresh}; extern: modsel.extern + "par2"}
            HSlider  { whenValue: lambda {base_osc.refresh}; extern: modsel.extern + "par3"}

            //bot
            Button { label: "as base"}

            //COL 2
            //shape
            TextBox  { label: "waveshaping"}
            Selector {whenValue: lambda {base_osc.refresh}; extern: base_osc.extern + "Pwaveshapingfunction"}
            HSlider  {whenValue: lambda {base_osc.refresh}; extern: base_osc.extern + "Pwaveshaping"}

            //pad
            Widget   {}

            //filter
            TextBox { label: "filter" }
            Selector { whenValue: lambda {base_osc.refresh}; extern: base_osc.extern + "Pfiltertype";}
            HSlider  { whenValue: lambda {base_osc.refresh}; extern: base_osc.extern + "Pfilterpar1";}
            HSlider  { whenValue: lambda {base_osc.refresh}; extern: base_osc.extern + "Pfilterpar2";}
            Button   { extern: base_osc.extern + "Pfilterbeforews"; label: "pre/post"}

            //bot
            Button {label: "auto-clear"}

            //COL 3

            //mag type
            TextBox { label: "mag. type"}
            Selector {}
            HSlider {extern: base_osc.extern + "Pharmonicshift"}
            Widget {
                Button  {label: "R"}
                Button  {extern: base_osc.extern + "Pharmonicshiftfirst"; label: "pre/post"}
                function layout(l) {
                    selfBox = l.genBox :idk, self
                    restBox = children[0].layout l
                    postBox = children[1].layout l
                    l.contains(selfBox, restBox)
                    l.contains(selfBox, postBox)
                    l.rightOf(restBox, postBox)
                    selfBox
                }

            }

            //pad
            Widget {}
            
            //adapt
            Selector {extern: base_osc.extern + "Padaptiveharmonics"}
            HSlider  {extern: base_osc.extern + "Padaptiveharmonicspower"}
            HSlider  {extern: base_osc.extern + "Padaptiveharmonicsbasefreq"}
            HSlider  {extern: base_osc.extern + "Padaptiveharmonicspar"}

            //bot
            Button {label: "clear all"}

            //COL 4

            //modulation
            TextBox { label: "modulation" }
            Selector { whenValue: lambda {base_osc.refresh}; extern: base_osc.extern + "Pmodulation"}
            HSlider  { whenValue: lambda {base_osc.refresh}; extern: base_osc.extern + "Pmodulationpar1"}
            HSlider  { whenValue: lambda {base_osc.refresh}; extern: base_osc.extern + "Pmodulationpar2"}
            HSlider  { whenValue: lambda {base_osc.refresh}; extern: base_osc.extern + "Pmodulationpar3"}

            //pad
            Widget {}


            //spectrum adj
            TextBox {label: "spectrum adj."}
            Selector {}
            HSlider {}

            //bot
            Button {label: "to sine"}

            function onSetup(old=nil)
            {
                children.each do |ch|
                    ch.layoutOpts = [:no_constraint]
                end
            }
            
            function layout(l)
            {
                selfBox = l.genBox :oscgrid, self
                chBox   = children.map {|x| x.layout l}
                pad = 3
                Draw::Layout::gridt(l, selfBox, chBox, 10, 4, pad, pad)
            }

        }

        function draw(vg) {
            Draw::GradBox(vg, Rect.new(0,0,w,h))
        }


        function layout(l)
        {
            selfBox = l.genBox :osc_mid, self
            pad = 6
            l.fixed_long(children[0].layout(l), selfBox, 0, 0, 1, 1,
            pad, pad, -2*pad, -2*pad)
            selfBox
        }
    }

    function layout(l)
    {
        selfBox = l.genBox :oscil, self
        baseBox = base.layout(l)
        fullBox = full.layout(l)
        bashBox = base_harm.layout(l)
        fulhBox = full_harm.layout(l)
        bastBox = base_title.layout(l)
        fultBox = full_title.layout(l)
        hediBox = hedit.layout(l)
        scrlBox = scroll.layout(l)
        voceBox = voice_button.layout(l)
        modbBox = mod_button.layout(l)
        middBox = middle_panel.layout(l)
        l.fixed(baseBox, selfBox, 0.00, 0.15, 0.30, 0.38)
        l.fixed(fullBox, selfBox, 0.70, 0.15, 0.30, 0.38)
        l.fixed(bashBox, selfBox, 0.00, 0.05, 0.30, 0.12)
        l.fixed(fulhBox, selfBox, 0.70, 0.05, 0.30, 0.12)
        l.fixed(bastBox, selfBox, 0.00, 0.00, 0.30, 0.05)
        l.fixed(fultBox, selfBox, 0.70, 0.00, 0.30, 0.05)
        l.fixed(hediBox, selfBox, 0.00, 0.53, 1.00, 0.42)
        l.fixed(scrlBox, selfBox, 0.10, 0.95, 0.80, 0.05)
        l.fixed(voceBox, selfBox, 0.00, 0.95, 0.10, 0.05)
        l.fixed(modbBox, selfBox, 0.90, 0.95, 0.10, 0.05)
        l.fixed(middBox, selfBox, 0.30, 0.0,  0.40, 0.53)

        selfBox
    }

}
