Widget {
    id: vis_filter

    property Array ypoints: []
    property Array xpoints: []

    onExtern: {
        return if vis_filter.extern.nil?
        meta = OSC::RemoteMetadata.new($remote, vis_filter.extern)

        vis_filter.valueRef = OSC::RemoteParam.new($remote, vis_filter.extern)
        vis_filter.valueRef.callback = Proc.new {|x|
            #puts "coeff"
            #puts x
            #puts
            #puts
            vis_filter.coeff = x;
            xpts = Draw::DSP::logspace(1, 20000, 256)
            ypts = []
            xpts.each do |pt|
                ypts << Draw::DSP::magnitude(x[1..3], x[4..6], pt/48000, x[0]+1)
            end
            vis_filter.xpoints = xpts
            vis_filter.ypoints = ypts
            root = vis_filter.root
            root.damage_item vis_filter if root
        }
    }

    extern: "/part0/kit0/adpars/GlobalPar/GlobalFilter/response"
    property Object valueRef: nil
    property Array  coeff:    nil

    function draw(vg)
    {
        background Theme::VisualBackground
        Draw::Grid::log_x(vg, 1, 20000, Rect.new(0, 0, w, h))
        Draw::Grid::linear_y(vg, 1, 20000, Rect.new(0, 0, w, h))

        puts coeff
        #puts ypoints.map {|x| Math.log10(x)}
        return if ypoints.empty?
        vg.path do |v|
            dx = w
            ch = h/2
            dy = h/8
            v.move_to(0, ch-dy*Math.log10(ypoints[0]))
            N = ypoints.length-1
            (1..N).each do |i|
                v.line_to(dx*i/N, ch-dy*Math.log10(ypoints[i]))
            end
            v.stroke_color color("00ff00")
            v.stroke
        end
    }
}
