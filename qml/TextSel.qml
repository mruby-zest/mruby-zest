Widget {
    id: textsel
    property Object valueRef: nil;
    property String extern: ""
    property Array  options: ["text", "test", "asdf"];
    property Array  opt_vals: []
    property Int    selected: 0
    property Function whenValue: nil

    onExtern: {
        meta = OSC::RemoteMetadata.new($remote,
                                       textsel.extern)
        #print "textsel extern = "
        #puts meta.options
        textsel.label   = meta.short_name
        textsel.tooltip = meta.tooltip
        if(meta.options)
            nopts = []
            vals  = []
            meta.options.each do |x|
                vals  << x[0]
                nopts << x[1]
            end
            textsel.options = nopts
            textsel.opt_vals = vals
        end
        textsel.valueRef = OSC::RemoteParam.new($remote, textsel.extern)
        textsel.valueRef.mode = :options
        textsel.valueRef.callback = Proc.new {|x| textsel.set_value(x)}
    }

    function set_value(x)
    {
        sel = 0
        opt_vals.each_with_index do |i, ind|
            sel = ind if i == x
        end

        self.selected = sel
        rt = self.root
        rt.damage_item self if rt
    }

    function layout(l)
    {
        t = widget.class_name.to_sym
        selfBox = l.genBox t, textsel
        if(!layoutOpts.include?(:no_constraint))
            scale = 100
            $vg.font_size scale
            bb = 1
            textsel.options.each do |x|
                x = x[0..8] if x.length > 8
                bbl  = $vg.text_bounds(0, 0, (x+"    ").upcase)
                bb   = [bb, bbl].max
            end
            scale *= layoutOpts[0] if layoutOpts.include?(:rescale)
            if(bb != 0)
                #Width cannot be so small that letters overflow
                l.sh([selfBox.w, selfBox.h], [-1.0, bb/scale], 0)
            end
        end
        selfBox
    }

    function class_name()
    {
        "TextSel"
    }

    function draw(vg)
    {
        text_color = Theme::TextColor
        pad  = 1/64
        pad2 = (1-2*pad)
        return if options[selected].nil?

        vg.font_face("bold")
        vg.font_size h*0.8
        vg.text_align NVG::ALIGN_LEFT | NVG::ALIGN_MIDDLE
        vg.fill_color text_color
        vg.text(3+w*pad*2,h/2,(options[selected]).upcase)
    }
}
