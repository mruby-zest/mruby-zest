Widget {
    id: wave_view
    property Bool   grid: true;
    property Object valueRef: nil
    property Float  phase: 0.0

    function class_name() { "WaveView" }

    onExtern: {
        wave_view.valueRef =
            OSC::RemoteParam.new($remote, wave_view.extern)
        wave_view.valueRef.callback = lambda {|x|
            data_view.data = x
            data_view.damage_self
        }
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


    function draw(vg)
    {
        pad  = 1/32
        pad2 = (1-2*pad)
        box = Rect.new(w*pad, h*pad, w*pad2, h*pad2)

        background Theme::VisualBackground

        if(grid)
            Draw::Grid::linear_x(vg,0,10,box, 0.5)
            Draw::Grid::linear_y(vg,0,10,box, 0.5)
        end

        if(extern.nil? || extern.empty?)
            Draw::WaveForm::sin(vg, box, 128)
        end
    }

    function refresh()
    {
        self.valueRef.refresh if(self.valueRef)
    }
}
