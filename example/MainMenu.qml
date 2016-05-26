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
        #l.rightOf(b[1], b[2])
        l.rightOf(b[2], b[3])
        l.rightOf(b[3], b[4])
        l.rightOf(b[4], b[5])
        l.topOf(b[0],b[3])
        l.topOf(b[1],b[4])
        l.topOf(b[1],b[5])
        b.each_with_index do |x,i|
            l.punish2([selfBox.w], [1.0/3.0], x.w)
            l.punish2([selfBox.h], [1.0/2.0], x.h)
        end
        selfBox
    }

    //0
    Button {id: file;   label: "file"; layoutOpts: [:no_constraint]}
    //1
    Button {id: learn;  label: "midi"; layoutOpts: [:no_constraint]}
    //2
    Button {id: rec;    renderer: "icon-record"}
    //3
    Button {id: pau;    renderer: "icon-pause"}
    //4
    Button {id: stop;   renderer: "icon-stop"}
    //5
    Button {id: aquire; label: "aquire"; layoutOpts: [:no_constraint]}
}
