Widget {
    id: basemod
    Widget {
        Widget {
            Widget {
                Swappable { id: vis }
            }
            Widget {
                Swappable { id: gen }
                Swappable { id: env }
                function layout(l, selfBox) {
                    Draw::Layout::hpack(l, selfBox, children)
                }
            }
            function layout(l, selfBox) {
                Draw::Layout::vfill(l, selfBox, children, [0.6,0.4])
            }
        }
        ZynOscilModRight {
            extern: basemod.extern
        }

        function layout(l, selfBox)
        {
            Draw::Layout::hfill(l, selfBox, children, [0.6,0.4])
        }
    }
    TabGroup {
        id: footer

        TabButton {
            label: "amplitude";
            highlight_pos: :top;
        }
        TabButton {
            label: "frequency";
            highlight_pos: :top
        }

        function set_tab(wid)
        {
            id = get_tab wid
            vs = [:amplitude, :frequency]
            root.set_view_pos(:subsubview, vs[id])
            root.change_view
        }
    }

    function layout(l, selfBox)
    {
        Draw::Layout::vfill(l, selfBox, children,
        [0.95,0.05])
    }

    function set_view()
    {
        subsubview = root.get_view_pos(:subsubview)
        vs = [:amplitude, :frequency]
        if(!vs.include?(subsubview))
            subsubview = :amplitude
            root.set_view_pos(:subsubview, subsubview)
        end
        if(subsubview == :amplitude)
            footer.children[0].value = true
            gen.extern  = basemod.extern
            env.extern  = basemod.extern + "FMAmpEnvelope/"
            vis.extern  = basemod.extern + "FMAmpEnvelope/"
            gen.content = Qml::ZynAmpMod
            env.content = Qml::ZynAmpEnv
            vis.content = Qml::ZynEnvEdit
            vis.children[0].layoutOpts = Hash.new
            vis.children[0].layoutOpts[:main_width] = 0.8

            env.children[0].toggleable   = basemod.extern + "PFMAmpEnvelopeEnabled"
            env.children[0].whenModified = lambda {
                elm = vis.children[0]
                elm.refresh if elm.respond_to? :refresh
            }
        else
            footer.children[1].value = true
            gen.extern  = basemod.extern
            env.extern  = basemod.extern + "FMFreqEnvelope/"
            vis.extern  = basemod.extern + "FMFreqEnvelope/"
            gen.content = Qml::ZynFreqMod
            env.content = Qml::ZynFreqEnv
            vis.content = Qml::ZynEnvEdit
            vis.children[0].layoutOpts = Hash.new
            vis.children[0].layoutOpts[:main_width] = 0.8

            env.children[0].toggleable   = basemod.extern + "PFMFreqEnvelopeEnabled"
            env.children[0].whenModified = lambda {
                elm = vis.children[0]
                elm.refresh if elm.respond_to? :refresh
            }
        end
        db.update_values
    }

    function onSetup(old=nil)
    {
        set_view
    }
}
