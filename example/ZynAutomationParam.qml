Widget {
    id: param
    property Bool active: true
    property Object valueRef: nil


    function draw(vg)
    {
        background(color("ffffff", 50)) if !param.active
    }

    function set_gain(gain) {
        plot.set_gain(gain)
    }

    function set_offset(offset) {
        plot.set_offset(offset)
    }


    ZynAutomationName {
        id: aname

    }
    Widget{
        PlotLabelY {
            id: yaxis
        }
        ZynAutomationPlot {id: plot}
        function layout(l, selfBox) {
            Draw::Layout::hfill(l, selfBox, children, [0.1, 0.9])
        }
    }
    ParModuleRow {
        Knob {
            id: gain
            label: "gain"
            value: 0.5
            type: "f"
            whenValue: lambda {plot.set_gain(4*(gain.value-0.5))}
        }
        Knob {
            id: offset
            label: "offset"
            value: 0.5
            type: "f"
            whenValue: lambda {plot.set_offset(offset.value-0.5)}
        }

        ClearBox {
            id: clr
            whenValue: lambda {$remote.action(param.extern + "clear")}
        }
    }

    function layout(l, selfBox) {
        Draw::Layout::vfill(l, selfBox, children, [0.1, 0.45, 0.35])
    }

    function onSetup(old=nil) {
    }

    function animate() {
        plot.set_gain(4*(gain.value-0.5))
        plot.set_offset(offset.value-0.5)
    }

    function update_path(path) {
        aname.update_path(path)
        if(path.empty?)
            mn   = -1
            mx   = 1
            yaxis.labels = [mn, ((mn+mx)/2), mx].map{|x| x.to_s}
            yaxis.damage_self
        else
            meta = OSC::RemoteMetadata.new($remote, path)
            mn   = meta.min
            mx   = meta.max
            if(mn && mx)
                yaxis.labels = [mn, ((mn+mx)/2), mx].map{|x| x.to_s}
                yaxis.damage_self
            end
        end
    }

    function update_value(val) {
        plot.input = 2*val-1
    }

    function update_active(val) {
        if(val != self.active)
            self.active = val
            damage_self
        end
    }

    onExtern: {
        if(self.valueRef)
            self.valueRef.each do |v|
                v.clean
            end
        end
        p = param
        ext = p.extern

        path_ref   =  OSC::RemoteParam.new($remote, ext + "path")
        active_ref =  OSC::RemoteParam.new($remote, ext + "active")
        value_ref  =  OSC::RemoteParam.new($remote, path_simp(ext + "../value"))

        value_ref.set_min(0.0)
        value_ref.set_max(1.0)
        value_ref.type = "f"

        path_ref.callback = lambda {|x| param.update_path(x)}
        active_ref.callback = lambda {|x| param.update_active(x)}
        value_ref.callback = lambda {|x| param.update_value(x)}

        gain.extern = ext + "mapping/gain"
        offset.extern = ext + "mapping/offset"


        p.valueRef = [path_ref, active_ref, value_ref]
    }
}
