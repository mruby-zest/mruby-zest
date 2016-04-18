Widget {
    id: center
    function layout(l)
    {
        #puts "Center layout"
        selfBox = l.genBox :zynCenter, center
        headBox  = header.layout(l)
        row1Box  = row1.layout(l)
        row2Box  = row2.layout(l)
        content  = explore.layout(l)
        row3Box  = row3.layout(l)
        #puts "layout the module"
        amplBox  = ampl.layout(l)
        freqBox  = freq.layout(l)
        filtBox  = filt.layout(l)
        amplEBox = ampl_env.layout(l)
        freqEBox = freq_env.layout(l)
        filtEBox = filt_env.layout(l)
        amplLBox = ampl_lfo.layout(l)
        freqLBox = freq_lfo.layout(l)
        filtLBox = filt_lfo.layout(l)
        #puts "module layout done"
        l.contains(selfBox, headBox)
        l.contains(selfBox, row1Box)
        l.contains(selfBox, row2Box)
        l.contains(selfBox, row3Box)

        #Top Row
        l.contains(row1Box,amplBox)
        l.contains(row1Box,freqBox)
        l.contains(row1Box,filtBox)

        l.rightOf(amplBox, freqBox)
        l.rightOf(freqBox, filtBox)

        #Second Row
        l.contains(row2Box,amplEBox)
        l.contains(row2Box,freqEBox)
        l.contains(row2Box,filtEBox)

        l.rightOf(amplEBox, freqEBox)
        l.rightOf(freqEBox, filtEBox)

        #Content
        l.contains(selfBox, content)

        #Third Row
        l.contains(row3Box,amplLBox)
        l.contains(row3Box,freqLBox)
        l.contains(row3Box,filtLBox)

        l.rightOf(amplLBox, freqLBox)
        l.rightOf(freqLBox, filtLBox)

        l.punish2([selfBox.w], [1/3.0], amplLBox.w)
        l.punish2([selfBox.w], [1/3.0], freqLBox.w)
        l.punish2([selfBox.w], [1/3.0], filtLBox.w)

        l.punish2([selfBox.w], [1/3.0], amplEBox.w)
        l.punish2([selfBox.w], [1/3.0], freqEBox.w)
        l.punish2([selfBox.w], [1/3.0], filtEBox.w)

        #Global Optimizatoin
        l.topOf(headBox, row1Box)
        l.topOf(row1Box, row2Box)
        l.topOf(row2Box, content)
        l.topOf(content, row3Box)

        l.sheq([headBox.h, selfBox.h], [1, -0.2*0.2], 0)
        l.sheq([row1Box.h, row2Box.h], [1, -1], 0)
        l.sheq([row1Box.h, row3Box.h], [1, -1], 0)
        l.le([row1Box.h, selfBox.h], [1, -0.2])
        l.le([content.h, selfBox.h], [1, -0.36])
        l.punish_difference(amplBox.w,amplEBox.w)
        l.punish_difference(freqBox.w,freqEBox.w)
        #puts "Center Layout Done"
       
        selfBox
    }
    Widget {
        id: header

        function measure(text)
        {
            bounds = Nanovg::Transform.new
            $vg.text_bounds(0,0,text,bounds)
            bw = bounds.c-bounds.a
            bh = bounds.d-bounds.b
            return bw,bh
        }

        function layout(l)
        {
            selfBox = l.genBox :zynCenterHeader, header
            prev = nil
            header.children.each do |ch|
                box = ch.layout(l)
                l.contains(selfBox,box)
                #bw,bh = measure(ch.label)

                #l.aspect(box, bh, bw)
                if(prev)
                    l.rightOf(prev, box)
                end
                prev = box
            end
            selfBox
        }

        Button { label: "<"}
        Button { label: "4"}
        Button { label: ">"}
        Button { label: "voice"}
        Button { label: "global parameters"}
        Button { label: "voice parameters"}
        Button { label: "voice & modulator oscillators"}
        Button { label: "voice list"}
        Button { label: "resonance"}
        Button { label: "c"}
        Button { label: "p"}
    }
    Widget {
        id: row1
        ParModule {
            id: ampl
            label: "amplitude"
            Knob { label: "vol" }
            Knob { label: "v.sns" }
            Knob { label: "pan" }
            Knob { label: "p.str" }
            Knob { label: "p.t." }
            Knob { label: "p.stc." }
            Knob { label: "p.vel." }
        }
        ParModule {
            id: freq
            label: "frequency"
            Knob {label: "detune"}
            Knob {label: "octave"}
            Knob {label: "rel.bw"}
            Knob {label: "coarse det."}
        }
        ParModule {
            id: filt
            label: "filter"
            Knob {label: "c.freq"}
            Knob {label: "q"}
            Knob {label: "v.sns a."}
            Knob {label: "freq. tr"}
            Knob {label: "gain"}
        }
    }

    Widget {
        id: row2
        ParModule {
            id: ampl_env
            label: "amplitude envelope"
            Knob { label: "a.dt" }
            Knob { label: "d.dt" }
            Knob { label: "s.val" }
            Knob { label: "stretch" }
            Button { label: "frcr" }
            Button { label: "L" }
        }
        ParModule {
            id: freq_env
            label: "frequency envelope"
            Knob { label: "a.dt" }
            Knob { label: "d.dt" }
            Knob { label: "s.val" }
            Knob { label: "r.dt" }
            Knob { label: "stretch" }
        }
        ParModule {
            id: filt_env
            label: "filter envelope"
            Knob { label: "a.dt" }
            Knob { label: "d.dt" }
            Knob { label: "s.val" }
        }
    }
    Envelope {
        id: explore
    }
    Widget {
        id: row3
        ZynLFO {
            id: ampl_lfo
            label: "amplitude lfo"
        }
        ZynLFO {
            id: freq_lfo
            label: "frequency lfo"
        }
        ZynLFO {
            id: filt_lfo
            label: "filter lfo"
        }
    }
}
