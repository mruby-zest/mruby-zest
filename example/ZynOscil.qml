Widget {
    id: base_osc
    property Bool doRefresh: false
    property Object delayRefresh: nil

    function animate()
    {
        if(doRefresh)
            self.doRefresh = false
            base.refresh
            full.refresh
            base_harm.refresh
            full_harm.refresh
            self.delayRefresh = Time.new + 0.1
        end

        #Super hacky workaround for data race in adsynth oscillators
        if(delayRefresh && Time.new > delayRefresh)
            base.refresh
            base_harm.refresh
            self.delayRefresh = nil
        end
    }

    function clear()
    {
        (0...128).each do |i|
            mval = 64
            pval = 64
            mval = 127 if i == 0
            $remote.seti(base_osc.extern + "magnitude" + i.to_s, mval)
            $remote.seti(base_osc.extern + "phase" + i.to_s,     pval)
        end
        refresh
    }

    function refresh()
    {
        self.doRefresh = true
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
        value: 0
        whenValue: lambda {hedit.set_scroll scroll.value}
    }

    //Button {
    //    id: voice_button
    //    layoutOpts: [:no_constraint]
    //    label: "voice"
    //}

    //Button {
    //    id: mod_button
    //    layoutOpts: [:no_constraint]
    //    label: "mod"
    //}

    Widget {
        id: middle_panel

        Widget {
            //COL 1
            //base
            TextBox { label: "base func."}
            Selector { extern: base_osc.extern + "Pcurrentbasefunc"}
            HSlider  { extern: base_osc.extern + "Pbasefuncpar"}
            Widget {}

            //modulation
            TextBox { label: "BF mod."}
            Selector { id: modsel; extern: base_osc.extern + "Pbasefuncmodulation"}
            HSlider  { extern: modsel.extern + "par1"}
            HSlider  { extern: modsel.extern + "par2"}
            HSlider  { extern: modsel.extern + "par3"}

            //bot
            TriggerButton {
                label: "as base"
                tooltip: "use combined waveform as base waveform"
                whenValue: lambda {
                    $remote.action(base_osc.extern+"use-as-base")
                }
            }

            //COL 2
            //shape
            TextBox  { label: "waveshaping"}
            Selector { extern: base_osc.extern + "Pwaveshapingfunction"}
            HSlider  { extern: base_osc.extern + "Pwaveshaping"}

            //pad
            Widget   {}

            //filter
            TextBox { label: "filter" }
            Selector { extern: base_osc.extern + "Pfiltertype";}
            HSlider  { extern: base_osc.extern + "Pfilterpar1";}
            HSlider  { extern: base_osc.extern + "Pfilterpar2";}
            Widget {}

            //bot
            ToggleButton   {
                extern: base_osc.extern + "Pfilterbeforews";
                label: "pre/post"
            }

            //COL 3

            //mag type
            TextBox { label: "mag. type"}
            Selector {extern: base_osc.extern + "Phmagtype" }
            HSlider {extern: base_osc.extern + "Pharmonicshift"}
            Widget {
                TriggerButton  {
                    label: "R"
                    whenValue: lambda {
                        $remote.action(base_osc.extern + "Pharmonicshift", 0.to_i)
                        base_osc.refresh
                    }
                }
                ToggleButton  {extern: base_osc.extern + "Pharmonicshiftfirst"; label: "pre/post"}
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
            TextBox {label: "adapt. harm."}

            //adapt
            Selector {extern: base_osc.extern + "Padaptiveharmonics"}
            HSlider  {extern: base_osc.extern + "Padaptiveharmonicspower"}
            HSlider  {extern: base_osc.extern + "Padaptiveharmonicsbasefreq"}
            HSlider  {extern: base_osc.extern + "Padaptiveharmonicspar"}

            //bot
            TriggerButton   {
                whenValue: lambda {base_osc.clear}
                label: "clear all"
                tooltip: "clear all harmonics"
            }

            //COL 4

            //modulation
            TextBox { label: "modulation" }
            Selector { extern: base_osc.extern + "Pmodulation"}
            HSlider  { extern: base_osc.extern + "Pmodulationpar1"}
            HSlider  { extern: base_osc.extern + "Pmodulationpar2"}
            HSlider  { extern: base_osc.extern + "Pmodulationpar3"}

            //pad
            Widget {}


            //spectrum adj
            TextBox {label: "spectrum adj."}
            Selector { extern: base_osc.extern + "Psatype"}
            HSlider  { extern: base_osc.extern + "Psapar"}

            //bot
            TriggerButton {
                label: "to sine"
                tooltip: "convert full waveform to sinasoidal components"
                whenValue: lambda {
                    $remote.action(base_osc.extern+"convert2sine")
                }
            }

            function onSetup(old=nil)
            {
                lam = lambda {base_osc.refresh}
                children.each do |ch|
                    ch.layoutOpts  = [:no_constraint]
                    ch.whenValue ||= lam if(ch.respond_to? :whenValue)
                end
            }

            function class_name() { "oscgrid" }
            function layout(l) {
                pad = 3
                Draw::Layout::gridt(l, self_box(l), chBoxes(l), 10, 4, pad, pad)
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
        #voceBox = voice_button.layout(l)
        #modbBox = mod_button.layout(l)
        middBox = middle_panel.layout(l)
        l.fixed(baseBox, selfBox, 0.00, 0.15, 0.30, 0.38)
        l.fixed(fullBox, selfBox, 0.70, 0.15, 0.30, 0.38)
        l.fixed(bashBox, selfBox, 0.00, 0.05, 0.30, 0.12)
        l.fixed(fulhBox, selfBox, 0.70, 0.05, 0.30, 0.12)
        l.fixed(bastBox, selfBox, 0.00, 0.00, 0.30, 0.05)
        l.fixed(fultBox, selfBox, 0.70, 0.00, 0.30, 0.05)
        l.fixed(hediBox, selfBox, 0.00, 0.53, 1.00, 0.42)
        l.fixed(scrlBox, selfBox, 0.00, 0.95, 1.00, 0.05)
        #l.fixed(scrlBox, selfBox, 0.10, 0.95, 0.80, 0.05)
        #l.fixed(voceBox, selfBox, 0.00, 0.95, 0.10, 0.05)
        #l.fixed(modbBox, selfBox, 0.90, 0.95, 0.10, 0.05)
        l.fixed(middBox, selfBox, 0.30, 0.0,  0.40, 0.53)

        selfBox
    }

}
