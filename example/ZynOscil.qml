Widget {
    extern: "/part0/kit0/adpars/VoicePar0/OscilSmp/"
    id: base_osc

    TitleBar {
        id: base_title
        label: "base waveform"
    }

    HarmonicView {
        id: base_harm
    }

    WaveView {
        id: base
    }

    TitleBar {
        id: full_title
        label: "full oscillator"
    }

    HarmonicView {
        id: full_harm
    }

    WaveView {
        id: full
    }

    HarmonicEdit {
        id: hedit
    }

    ScrollBar {
        id: scroll
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

        Selector { extern: base_osc.extern + "Pcurrentbasefunc"}
        Knob     { extern: base_osc.extern + "Pbasefuncpar"}
        Selector { id: modsel; extern: base_osc.extern + "Pbasefuncmodulation"}
        Knob     { extern: modsel.extern + "par1"}
        Knob     { extern: modsel.extern + "par2"}
        Knob     { extern: modsel.extern + "par3"}
    }

    ParModuleRow {
        id: more_pars
        function draw(vg) { background color("334454") }
        Button { layoutOpts: [:no_constraint]; label: "use as base" }
        Button { label: "sine" }
        Button { layoutOpts: [:no_constraint]; label: "clear" }
    }

    ColorBox {
        id: middle_panel
        bg: color("222222")

        ColorBox {
            id: shape
            bg: Theme::GeneralBackground
            pad: 0.01
            layoutOpts: [:think_of_the_children]
            Selector {extern: base_osc.extern + "Pwaveshapingfunction"}
            Knob     {extern: base_osc.extern + "Pwaveshaping"}
        }

        ColorBox {
            id: filter
            bg: Theme::GeneralBackground
            pad: 0.01
            layoutOpts: [:think_of_the_children]
            Selector { extern: base_osc.extern + "Pfiltertype";}
            Knob     { extern: base_osc.extern + "Pfilterpar1";}
            Knob     { extern: base_osc.extern + "Pfilterpar2";}
            Button   { extern: base_osc.extern + "Pfilterbeforews"; label: "pre/post"}
        }

        ColorBox {
            id: shift
            bg: Theme::GeneralBackground
            pad: 0.01
            layoutOpts: [:think_of_the_children]
            Knob   {extern: base_osc.extern + "Pharmonicshift"}
            Button {label: "R"}
            Button {extern: base_osc.extern + "Pharmonicshiftfirst"; label: "pre/post"}
        }

        ColorBox {
            id: adapt
            bg: Theme::GeneralBackground
            pad: 0.01
            layoutOpts: [:think_of_the_children]
            Selector {extern: base_osc.extern + "Padaptiveharmonics"}
            Knob     {extern: base_osc.extern + "Padaptiveharmonicspower"}
            Knob     {extern: base_osc.extern + "Padaptiveharmonicsbasefreq"}
            Knob     {extern: base_osc.extern + "Padaptiveharmonicspar"}
        }

        ColorBox {
            id: modulate
            bg: Theme::GeneralBackground
            pad: 0.01
            layoutOpts: [:think_of_the_children]
            Selector { extern: base_osc.extern + "Pmodulation"}
            Knob     { extern: base_osc.extern + "Pmodulationpar1"}
            Knob     { extern: base_osc.extern + "Pmodulationpar2"}
            Knob     { extern: base_osc.extern + "Pmodulationpar3"}
        }

        ColorBox {
            id: spec_adjust
            bg: Theme::GeneralBackground
            pad: 0.01
            layoutOpts: [:think_of_the_children]
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
        l.fixed(baseBox, selfBox, 0.00, 0.1,  0.4, 0.4)
        l.fixed(fullBox, selfBox, 0.60, 0.1,  0.4, 0.4)
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
