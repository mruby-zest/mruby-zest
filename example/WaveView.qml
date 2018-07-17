Widget {
    id: wave_view
    property Bool   grid: true;
    property Object valueRef: nil
    property Float  phase: 0.0
    property String noise: nil
    property Bool   noise_mode: false

    function class_name() { "WaveView" }

    onExtern: {
        data = OSC::RemoteParam.new($remote, wave_view.extern)
        data.callback = lambda {|x|
            data_view.data = x if !wave_view.noise_mode
            data_view.damage_self
        }
        noise = nil
        if(wave_view.noise)
            noise = OSC::RemoteParam.new($remote, wave_view.noise)
            noise.callback = lambda {|x|
                wave_view.set_noise_mode(x != 0)
            }
        end
        if(noise)
            wave_view.valueRef = [data, noise]
        else
            wave_view.valueRef = [data]
        end
    }

    onPhase: {
        return if((data_view.phase*100).to_i == (wave_view.phase*100).to_i)
        data_view.phase = wave_view.phase

        data_view.damage_self
    }

    DataView {
        id: data_view
        phase: wave_view.phase
    }

    function set_noise_mode(x)
    {
        return if x == self.noise_mode
        self.noise_mode = x
        if(self.noise_mode)
            #Draw a N
            u = []
            20.times  { u << 0.0 }
            10.times  { u << 0.8 }
            20.times  {|x| u << (x/19)*-1.0+0.8 }
            10.times  { u << 0.8 }
            20.times  { u << 0.0 }
            l = []
            20.times  { l << 0.0 }
            10.times   { l << -0.8 }
            20.times  {|x| l << (x/19)*-1.0+0.2 }
            10.times   { l << -0.8 }
            20.times  { l << 0.0 }
            data_view.ignore_phase = true
            data_view.data = [u, l]
            data_view.damage_self
        else
            data_view.ignore_phase = false
            self.valueRef[0].refresh if valueRef
        end
    }


    function draw(vg)
    {
        pad  = 1/32
        pad2 = (1-2*pad)
        box = Rect.new(w*pad, h*pad, w*pad2, h*pad2)

        background Theme::VisualBackground

        if(grid)
            Draw::Grid::linear_x(vg,0,10,box, 1.0)
            Draw::Grid::linear_y(vg,0,10,box, 1.0)
        end

        if(extern.nil? || extern.empty?)
            Draw::WaveForm::sin(vg, box, 128)
        end
    }

    function refresh()
    {
        return if self.valueRef.nil?
        self.valueRef.each do |v|
            v.refresh
        end
    }
}
