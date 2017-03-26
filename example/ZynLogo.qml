Widget {
    function draw_placeholder(vg)
    {
        #background color("123456")
        #vg.path do |v|
        #    v.rect(0, 0, w, h)
        #    v.fill_color(NVG.rgba(0xaa, 0xaa, 0xaa, 255))
        #    v.fill
        #end
        logo_top = color("4DC3C7")
        logo_bot = color("56C0A5")

        vg.path do |v|
            l = 0.4*w
            v.move_to(0,0)
            v.line_to(l,      0.1*h)
            v.line_to(l*0.75, 0.6*h)
            v.close_path
            v.fill_color logo_top
            v.fill
        end

        vg.path do |v|
            l = 0.4*w
            v.move_to(l,h)
            v.line_to(0,      0.9*h)
            v.line_to(l*0.25, 0.4*h)
            v.close_path
            v.fill_color logo_bot
            v.fill
        end

        vg.font_face("bold")
        vg.font_size h*0.8
        vg.text_align NVG::ALIGN_LEFT | NVG::ALIGN_MIDDLE
        vg.fill_color logo_top
        vg.text(w*1/2,h/2,"ZYN")
    }

    function draw_path(vg, path, co)
    {
        wscale = 80.0
        hscale = 35.0
        n = path.length/2
        xmin = 64
        ymin = 60
        vg.path do
            xx = (w*(path[2*0+0]-xmin)/wscale).round
            yy = (h*(path[2*0+1]-ymin)/hscale).round
            vg.move_to(xx, yy)
            (1...n).each do |i|
                xx = (w*(path[2*i+0]-xmin)/wscale).round
                yy = (h*(path[2*i+1]-ymin)/hscale).round
                vg.line_to(xx,yy)
            end
            vg.close_path
            vg.fill_color co
            vg.fill
            #vg.stroke_color color("2E3239")
            #vg.stroke_width 2.0
            #vg.stroke
        end
    }

    function draw_new(vg)
    {
        st0 = color("686868")
        st1 = color("2E3239")
        st1 = color("010101")
        st2 = color("50C3C7")
        st3 = color("57C1A6")

        st1
        path_1 = [97,64,64,61,67.3,63.3,64,63,87,79,97,66,95.6,65.9]
        path_2 = [97,90,74,74,64,87,65.4,87.1,64,89,97,92,93.7,89.7]
        path_3 = [103,69,103.7,71,103,71,104,74,107.5,74,103,80,103,82.1,103,83,103,85,115,85,115,83,115,81.4,115,80,110.3,80,115,74,115,72,115,71,115,69]
        path_4 = [129,69,124,69,123,74,122,69,117,69,117.8,71,117,71,121,81,121,83,121,85,125,85,125,83,125,81,129,71,128.2,71]
        path_5 = [131,69,135,69,138.5,74,138.8,75,139,75,139,69,143,69,143,85,139,85,135.5,80,135.8,79,135,79,135,85,131,85]
        draw_path(vg, path_1, st1)
        draw_path(vg, path_2, st1)
        draw_path(vg, path_3, st1)
        draw_path(vg, path_4, st1)
        draw_path(vg, path_5, st1)

        st2 
        path_6 = [64,62,97,65,87,78]
        path_7 = [115,84,103,84,103,81,109,73,109,73,104,73,103,70,115,70,115,73,109,81,109,81,115,81,115,84]
        path_8 = [122,70,123,75,123,75,124,70,129,70,125,80,125,84,121,84,121,80,117,70]
        path_9 = [131,70,135,70,138.5,75,138.8,76,139,76,139,70,143,70,143,84,139,84,135.5,79,135.8,78,135,78,135,84,131,84]
        draw_path(vg, path_6, st2)
        draw_path(vg, path_7, st2)
        draw_path(vg, path_8, st2)
        draw_path(vg, path_9, st2)

        st3
        path_10 = [97,91,64,88,74,75]
        draw_path(vg, path_10, st3)
    }


    function draw(vg)
    {
        #draw_placeholder(vg)
        draw_new(vg)
    }

    function onMousePress(m)
    {
        view = root.get_view_pos(:view)
        root.set_view_pos(:view, :about)    if(view != :about)
        root.set_view_pos(:view, :automate) if(view == :about)
        root.change_view
    }
}
