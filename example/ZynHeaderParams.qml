Widget {
    HSlider {height: 0.8; label: "detune" }
    HSlider {extern: "/Pvolume"; height: 0.8; label: "volume" }
    Button  {layoutOpts: [:no_constraint]; label: "nrpn" }
    HSlider {extern: "/Pkeyshift"; height: 0.8; label: "key shift" }

    function layout(l)
    {
        selfBox = l.genBox :headersub, self
        chBox   = chBoxes(l)

        padw  = 1/256
        padw2 = 0.5-2*padw
        padh = 1/32
        padh2 = 0.5-2*padh
        l.fixed(chBox[0], selfBox, 0.0+padw, 0.0+padh, padw2, padh2)
        l.fixed(chBox[1], selfBox, 0.5+padw, 0.0+padh, padw2, padh2)
        l.fixed(chBox[2], selfBox, 0.0+padw, 0.5+padh, padw2, padh2)
        l.fixed(chBox[3], selfBox, 0.5+padw, 0.5+padh, padw2, padh2)

        selfBox
    }
}
