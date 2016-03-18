Widget {
    id: window
    w: 2362
    h: 1340
    function class_name() { "MainWindow" }

    function layout(l)
    {
        puts "Main Window layout"
        t = widget.class_name.to_sym
        selfBox = l.genBox t, widget
        chBox = main_widget.layout(l)
        l.sheq([chBox.x, selfBox.w], [1, -0.102], 0)
        l.sheq([chBox.w, selfBox.w], [1, -0.89], 0)
        l.sheq([chBox.y, selfBox.h], [1, -0.1], 0)
        l.sheq([chBox.h, selfBox.h], [1, -0.78], 0)
        side.layout(l)
        selfBox
    }

    function draw(vg)
    {
       vg.path do |v|
           v.rect(0, 0, w, h)
           v.fill_color(NVG.rgba(0x0d, 0x0d, 0x0d, 255))
           v.fill
       end
    }
    
    ZynSidebar {
        id: side
        x: 0
        y: 0.1*window.h
        w: 0.1*window.w
        h: 0.8*window.h
        function draw(vg)
        {
            vg.path do |v|
                v.rect(0, 0, w, h)
                v.fill_color(NVG.rgba(0x2d, 0x2d, 0x2d, 255))
                v.fill
            end
        }
    }
    ZynHeader {
        id: head1
        x: 0
        y: 0
        w: window.w
        h: 0.1*window.h
        function draw(vg)
        {
            vg.path do |v|
                v.rect(0, 0, w, h)
                v.fill_color(NVG.rgba(0x2d, 0x2d, 0x2d, 255))
                v.fill
            end
        }
    }
    ZynFooter {
        id: sub1
        x: 0
        y: 0.9*window.h
        w: window.w
        h: 0.1*window.h
        function draw(vg)
        {
            vg.path do |v|
                v.rect(0, 0, w, h)
                v.fill_color(NVG.rgba(128, 128, 128, 255))
                v.fill_color(NVG.rgba(0x2d, 0x2d, 0x2d, 255))
                v.fill
            end
        }
    }
    ZynCenter {
        id: main_widget
    }
}
