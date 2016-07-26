Widget {
    id: meter
    property Object valueRef: nil
    property Object data: nil

    function animate() {
        self.valueRef.refresh if(self.valueRef)
    }

    function rap2dB(x) { 20*Math::log10(x) }
    function bound(x)  { [0.0, [1.0, x].min].max }
    function cv(x)     {min_db = -40;bound((min_db-rap2dB(x))/min_db)}

    function draw(vg)
    {
        indent_color = Theme::VisualBackground
        background indent_color

        bar_color = Theme::VisualLine
        pad  = 3
        pad2 = (h-2*pad)
        v1 = 0.3
        v2 = 0.5
        if(!data.nil?)
            v1 = cv(data[0])
            v2 = cv(data[1])
        end

        vg.path do |v|
            v.rect(pad,(1-v1)*pad2, 0.2*w, (v1)*(h-pad))
            v.fill_color bar_color
            v.fill
        end

        vg.path do |v|
            v.rect(0.8*w-pad,(1-v2)*pad2, 0.2*w, (v2)*(h-pad))
            v.fill_color bar_color
            v.fill
        end
    }

    function update_data(x)
    {
        if(self.data != x)
            self.data = x
            self.damage_self
        end
    }

    function onSetup(old=nil)
    {
        self.valueRef = OSC::RemoteParam.new($remote, "/vu-meter")
        self.valueRef.callback = lambda {|x| meter.update_data(x) }
        animate() if self.data
    }
}
