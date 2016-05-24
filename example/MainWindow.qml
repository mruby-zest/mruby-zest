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
        chBox   = main_widget.layout(l)
        sideBox = side.layout(l)

        l.fixed(chBox, selfBox, 0.102, 0.1, 0.89, 0.78)
        l.fixed(sideBox, selfBox, 0, 0.1, 0.1, 0.8)

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
    ZynAddGlobal {
        id: main_widget
    }
}
