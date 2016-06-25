Widget {
    id: menu
    function layout(l)
    {
        selfBox = l.genBox :menu, menu
        chBox   = chBoxes(l)

        pad  = 1/32
        pad2 = 0.5-2*pad
        l.fixed(chBox[0], selfBox, 0.0+pad, 0.0+pad, pad2, pad2)
        l.fixed(chBox[1], selfBox, 0.5+pad, 0.0+pad, pad2, pad2)
        l.fixed(chBox[2], selfBox, 0.0+pad, 0.5+pad, pad2, pad2)
        l.fixed(chBox[3], selfBox, 0.5+pad, 0.5+pad, pad2, pad2)

        selfBox
    }

    //0
    Button {id: file;   label: "file"; layoutOpts: [:no_constraint]}
    //1
    Button {id: learn;  label: "midi"; layoutOpts: [:no_constraint]}
    //2
    Record {}
    //3
    Button {id: acquire; label: "learn"; layoutOpts: [:no_constraint]}
}
