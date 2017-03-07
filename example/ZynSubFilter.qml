Widget {
    id: subfl

    property Object valueRef: nil
    property Symbol filtertype: nil

    function change_vis(x)
    {
        root.set_view_pos(:vis, x)
        root.change_view
    }

    //visual
    Swappable {
        id: edit
    }

    Widget {
        ZynAnalogFilter {
            id: gen
            subsynth: true
            toggleable: subfl.extern + "PGlobalFilterEnabled"
            extern: subfl.extern + "GlobalFilter/"
            whenClick: lambda { subfl.change_vis(:filter) }
        }
        ZynFilterEnv {
            id: env
            extern: subfl.extern+"GlobalFilterEnvelope/"
            whenClick: lambda { subfl.change_vis(:envlope) }
        }
        function layout(l, selfBox) {
            Draw::Layout::hpack(l, selfBox, children)
        }
    }

    function layout(l, selfBox) {
        Draw::Layout::vfill(l, selfBox, children, [0.6, 0.4])
    }

    function set_vis_env(ext)
    {
        edit.extern  = ext + "GlobalFilterEnvelope/"
        edit.content = Qml::ZynEnvEdit
        env.whenModified = lambda {
            elm = edit.children[0]
            elm.refresh if elm.respond_to? :refresh
        }
    }

    function set_vis_filter(ext)
    {
        edit.extern = ext + "GlobalFilter/"
        if(self.filtertype == :formant)
            edit.content = Qml::ZynFormant
        elsif(!children.empty?)
            edit.children[0].extern = ext + "GlobalFilter/response"
            edit.content = Qml::VisFilter
        end
        gen.whenModified = lambda {
            elm = edit.children[0]
            elm.refresh if elm.respond_to? :refresh
        }
    }

    function set_view()
    {
        base = self.extern
        vis  = root.get_view_pos(:vis)

        types = [:envelope, :lfo, :filter]
        if(!types.include?(vis))
            vis = :envelope
            root.set_view_pos(:vis, vis)
        end

        if(vis == :envelope)
            set_vis_env(base)
        elsif(vis == :filter)
            set_vis_filter(base)
        end
    }

    onExtern: {
        subfl.add_cat()
    }

    function add_cat()
    {
        return if self.valueRef
        if(self.valueRef.nil?)
            path = self.extern + "GlobalFilter/Pcategory"
            self.valueRef = OSC::RemoteParam.new($remote, path)
            self.valueRef.mode = :full
            self.valueRef.callback = lambda {|x|
                subfl.filtertype = [:analog, :formant, :statevar][x]
            }
        end
    }

    function onSetup(old=nil) {

        gen.move_sense()
        set_view()
    }
}
