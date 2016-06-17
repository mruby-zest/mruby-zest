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

    ParModuleRow {
        id: base_pars
        function draw(vg) { background color("334454") }
        Selector { extern: base_osc.extern + "Phmagtype"}
        Knob     {}
        Selector {}
        Knob     { extern: base_osc.extern + "Pamprandpower"}
    }

    ParModuleRow {
        id: oscil_pars
        function draw(vg) { background color("334454") }

        Selector { whenValue: lambda {base_osc.refresh}; extern: base_osc.extern + "Pcurrentbasefunc"}
        Knob     { whenValue: lambda {base_osc.refresh}; extern: base_osc.extern + "Pbasefuncpar"}
        Selector { whenValue: lambda {base_osc.refresh}; id: modsel; extern: base_osc.extern + "Pbasefuncmodulation"}
        Knob     { whenValue: lambda {base_osc.refresh}; extern: modsel.extern + "par1"}
        Knob     { whenValue: lambda {base_osc.refresh}; extern: modsel.extern + "par2"}
        Knob     { whenValue: lambda {base_osc.refresh}; extern: modsel.extern + "par3"}
    }

    ColorBox {
        id: more_pars
        bg: Theme::GeneralBackground
        Button { layoutOpts: [:no_constraint]; label: "as base" }
        Button { layoutOpts: [:no_constraint]; label: "sine" }
        Button { layoutOpts: [:no_constraint]; label: "clear" }
        function layout(l) {
            selfBox = l.genBox :morepars, self
            ch = children.map {|x| x.layout l}
            Draw::Layout::hfill(l, selfBox, ch, [0.4, 0.2, 0.25], 0.05)
        }
    }

    ColorBox {
        id: middle_panel
        bg: color("222222")

        VGroup {
            id: shape
            Selector {whenValue: lambda {base_osc.refresh}; extern: base_osc.extern + "Pwaveshapingfunction"}
            Knob     {whenValue: lambda {base_osc.refresh}; extern: base_osc.extern + "Pwaveshaping"}
        }

        VGroup {
            id: filter
            Selector { whenValue: lambda {base_osc.refresh}; extern: base_osc.extern + "Pfiltertype";}
            Knob     { whenValue: lambda {base_osc.refresh}; extern: base_osc.extern + "Pfilterpar1";}
            Knob     { whenValue: lambda {base_osc.refresh}; extern: base_osc.extern + "Pfilterpar2";}
            Button   { extern: base_osc.extern + "Pfilterbeforews"; label: "pre/post"}
        }

        VGroup {
            id: shift
            Knob   {extern: base_osc.extern + "Pharmonicshift"}
            Button {label: "R"}
            Button {extern: base_osc.extern + "Pharmonicshiftfirst"; label: "pre/post"}
        }

        VGroup {
            id: adapt
            Selector {extern: base_osc.extern + "Padaptiveharmonics"}
            Knob     {extern: base_osc.extern + "Padaptiveharmonicspower"}
            Knob     {extern: base_osc.extern + "Padaptiveharmonicsbasefreq"}
            Knob     {extern: base_osc.extern + "Padaptiveharmonicspar"}
        }

        VGroup {
            id: modulate
            Selector { whenValue: lambda {base_osc.refresh}; extern: base_osc.extern + "Pmodulation"}
            Knob     { whenValue: lambda {base_osc.refresh}; extern: base_osc.extern + "Pmodulationpar1"}
            Knob     { whenValue: lambda {base_osc.refresh}; extern: base_osc.extern + "Pmodulationpar2"}
            Knob     { whenValue: lambda {base_osc.refresh}; extern: base_osc.extern + "Pmodulationpar3"}
        }

        VGroup {
            id: spec_adjust
            Selector {}
            Knob {}
        }

        function layout(l)
        {
            selfBox = l.genBox :osc_mid, self
            shpeBox = shape.layout(l)
            filtBox = filter.layout(l)
            shftBox = shift.layout(l)
            adapBox = adapt.layout(l)
            moduBox = modulate.layout(l)
            specBox = spec_adjust.layout(l)

            l.fixed(shpeBox, selfBox, 0.0, 0.0, 0.3, 0.5)
            l.fixed(filtBox, selfBox, 0.0, 0.5, 0.3, 0.5)
            l.fixed(shftBox, selfBox, 0.3, 0.0, 0.4, 0.5)
            l.fixed(adapBox, selfBox, 0.3, 0.5, 0.4, 0.5)
            l.fixed(moduBox, selfBox, 0.7, 0.0, 0.3, 0.5)
            l.fixed(specBox, selfBox, 0.7, 0.5, 0.3, 0.5)

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
        bsepBox = base_pars.layout(l)
        oscpBox = oscil_pars.layout(l)
        moreBox = more_pars.layout(l)
        middBox = middle_panel.layout(l)
        l.fixed(baseBox, selfBox, 0.00, 0.1,  0.4, 0.38)
        l.fixed(fullBox, selfBox, 0.60, 0.1,  0.4, 0.38)
        l.fixed(bashBox, selfBox, 0.00, 0.03, 0.4, 0.07)
        l.fixed(fulhBox, selfBox, 0.60, 0.03, 0.4, 0.07)
        l.fixed(bastBox, selfBox, 0.00, 0.00, 0.4, 0.03)
        l.fixed(fultBox, selfBox, 0.60, 0.00, 0.4, 0.03)
        l.fixed(hediBox, selfBox, 0.00, 0.65, 1.0, 0.3)
        l.fixed(scrlBox, selfBox, 0.10, 0.95, 0.8, 0.05)
        l.fixed(voceBox, selfBox, 0.00, 0.95, 0.1, 0.05)
        l.fixed(modbBox, selfBox, 0.90, 0.95, 0.1, 0.05)
        l.fixed(bsepBox, selfBox, 0.00, 0.5,  0.4, 0.15)
        l.fixed(bsepBox, selfBox, 0.00, 0.5,  0.4, 0.15)
        l.fixed(oscpBox, selfBox, 0.60, 0.5,  0.4, 0.15)
        l.fixed(moreBox, selfBox, 0.40, 0.6,  0.2, 0.05)
        l.fixed(middBox, selfBox, 0.40, 0.0,  0.2, 0.6)

        selfBox
    }

}
