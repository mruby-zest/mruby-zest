Widget {
    id: menu
    function layout(l)
    {
        puts "MainMenu Layout"
        selfBox = l.genBox :menu, menu

        b = []
        menu.children.each do |ch|
            bb = ch.layout(l)
            l.contains(selfBox, bb)
            b << bb
        end
        l.rightOf(b[0], b[1])
        l.rightOf(b[1], b[2])
        l.rightOf(b[2], b[3])
        l.rightOf(b[4], b[5])
        l.rightOf(b[5], b[6])
        l.topOf(b[0],b[4])
        l.topOf(b[1],b[5])
        l.topOf(b[2],b[5])
        l.topOf(b[3],b[6])
        b.each_with_index do |x,i|
            if([0,1].include? i)
                l.punish2([selfBox.w], [1.0/6.0], b[0].w)
            else
                l.punish2([selfBox.w], [1.0/3.0], x.w)
            end
            l.punish2([selfBox.h], [1.0/2.0], x.h)
        end
        selfBox
    }

    //0
    DropDown {id: file; text: "file" }
    //1
    Button {id: key;    renderer: "icon-keyboard"}
    //2
    Button {id: learn;  label: "midi learn"}
    //3
    Button {id: rec;    renderer: "icon-record"}
    //4
    Button {id: pau;    renderer: "icon-pause"}
    //5
    Button {id: stop;   renderer: "icon-stop"}
    //6
    Button {id: aquire; label: "aquire"}
}
