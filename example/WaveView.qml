Widget {
    id: wave_view
    property Bool  grid: true;
    property Object valueRef: nil
    
    function class_name() { "WaveView" }

    onExtern: {
        wave_view.valueRef =
            OSC::RemoteParam.new($remote, wave_view.extern)
        wave_view.valueRef.callback = lambda {|x|
            data_view.data = x
            data_view.damage_self
        }
    }

    DataView { id: data_view }


    function draw(vg)
    {
        pad  = 1/32
        pad2 = (1-2*pad)
        box = Rect.new(w*pad, h*pad, w*pad2, h*pad2)

        background Theme::VisualBackground

        if(grid)
            Draw::Grid::linear_x(vg,0,10,box, 0.3)
            Draw::Grid::linear_y(vg,0,10,box, 0.4)
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
