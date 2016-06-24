Widget {
    property Float pad: 1/32
    function draw(vg)
    {
        pad2 = (1-2*pad)
        box = Rect.new(w*pad, h*pad, w*pad2, h*pad2)

        background Theme::VisualBackground

        Draw::Grid::linear_x(vg,0,10,box, 0.5)
        Draw::Grid::linear_y(vg,0,10,box, 0.5)

        xpoints = Draw::DSP::linspace(-2,2,128)
        ypoints = xpoints.map {|x| 2*Math.exp(-x**2/0.1)-1 }

        Draw::WaveForm::plot(vg, ypoints, box)

        vg.path do |v|
            v.move_to(0.5*w+0.15*w, h*pad)
            v.line_to(0.5*w+0.15*w, h*pad2)
            v.move_to(0.5*w-0.15*w, h*pad)
            v.line_to(0.5*w-0.15*w, h*pad2)
            v.stroke_color Theme::VisualStroke
            v.stroke
        end

        vg.path do |v|
            v.rect(0.5*w-0.15*w, h*pad, 0.3*w, h*pad2)
            v.fill_color Theme::VisualLightFill
            v.fill
        end
        vg.path do |v|
            v.move_to(0, h)
            n = ypoints.length
            ypoints.each_with_index do |y, i|
                v.line_to(w*i/n, (1-y)/2*h)
            end
            v.close_path
            v.fill_color Theme::VisualLightFill
            v.fill
        end
    }
}
