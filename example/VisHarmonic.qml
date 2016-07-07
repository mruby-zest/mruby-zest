Widget {
    id: hm
    property Float pad: 1/32
    property Object valueRef: nil
    property Array  points:   nil

    onExtern: {
        hm.valueRef = OSC::RemoteParam.new($remote, hm.extern)
        hm.valueRef.callback = Proc.new {|x| hm.setValue(x)}
    }

    function setValue(x)
    {
        self.points = x
    }

    function draw(vg)
    {
        pad2 = (1-2*pad)
        box = Rect.new(w*pad, h*pad, w*pad2, h*pad2)

        background Theme::VisualBackground

        Draw::Grid::linear_x(vg,0,10,box, 0.5)
        Draw::Grid::linear_y(vg,0,10,box, 0.5)

        xpoints = nil
        ypoints = nil
        if(self.points)
            ypoints = self.points[1..-1]
        else
            ypoints = xpoints.map {|x| 2*Math.exp(-x**2/0.1)-1 }
        end

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
            v.move_to(pad*w, h*(pad+pad2))
            n = ypoints.length
            ypoints.each_with_index do |y, i|
                v.line_to(pad*w+pad2*w*i/n, (1-y)/2*h)
            end
            puts "asdf"
            v.line_to((pad+pad2)*w,(pad+pad2)*h)
            v.close_path
            v.fill_color Theme::VisualLightFill
            v.fill
        end
    }
}
