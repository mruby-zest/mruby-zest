Widget {
    id: oscil_top

    TitleBar {
        id: base_title
    }

    HarmonicView {
        id: base_harm
    }

    WaveView {
        id: base
    }

    TitleBar {
        id: full_title
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
        function draw(vg)
        {
            vg.path do |v|
                v.rect(0, 0, w, h)
                v.fill_color(color("334454"))
                v.fill
            end
        }
        Selector {}
        Knob {}
        Selector {}
        Knob {}
    }

    ParModuleRow {
        id: oscil_pars
        function draw(vg)
        {
            vg.path do |v|
                v.rect(0, 0, w, h)
                v.fill_color(color("334454"))
                v.fill
            end
        }

        Selector {}
        Knob {}
        Selector {}
        Knob {}
        Knob {}
        Knob {}
    }

    ParModuleRow {
        id: more_pars
        function draw(vg)
        {
            vg.path do |v|
                v.rect(0, 0, w, h)
                v.fill_color(color("334454"))
                v.fill
            end
        }
        Button { layoutOpts: [:no_constraint]; label: "use as base" }
        Button { label: "sine" }
        Button { layoutOpts: [:no_constraint]; label: "clear" }
    }

    ColorBox {
        id: middle_panel
        bg: color("228855")

        ColorBox {
            id: shape
            bg: color("184923")
        }

        ColorBox {
            id: filter
            bg: color("884923")
        }

        ColorBox {
            id: shift
            bg: color("223999")
        }

        ColorBox {
            id: adapt
            bg: color("22f999")
        }

        ColorBox {
            id: modulate
            bg: color("92a929")
        }

        ColorBox {
            id: spec_adjust
            bg: color("f239f9")
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
