Widget {
    id: info_box
    //Name Header       1-line
    //Namebox           1-line
    //Author Header     1-line
    //Author            4-line
    //Comments Header   1-line
    //Comments          8-line
    TextBox {label: "name"}
    TextLine {
        id: namebox
    }
    TextBox {label: "name"}
    TextEdit {
        id: authbox
        height: 0.25
    }
    TextBox {label: "comments"}
    TextEdit {
        id: commbox
        height: 1.0/8.0
    }

    function layout(l)
    {
        weights = Draw::DSP::norm_sum([1,1,1,4,1,8])

        Draw::Layout::vfill(l, self_box(l), chBoxes(l), weights)
    }

    function set_view()
    {
        prt = root.get_view_pos(:part)
        namebox.extern = "/part#{prt}/Pname"
        authbox.extern = "/part#{prt}/info.Pauthor"
        commbox.extern = "/part#{prt}/info.Pcomments"
    }

    function onSetup(old=nil)
    {
        set_view()
    }
}
