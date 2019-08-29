  ZynAnalogFilter {
            subsynth: true
            toggleable: "/part0/kit0/subpars/PGlobalFilterEnabled"
            extern: self.extern  + "GlobalFilter/"
            whenClick: lambda { root.set_view_pos(:vis, :filter); parent.parent.parent.set_view() }
            whenModified: lambda { elm = parent.parent.parent.row1.children[0]; elm.refresh if elm.respond_to? :refresh}
        }