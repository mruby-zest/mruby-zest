Widget {
    id: selector
    property Object valueRef: nil;
    property String extern: ""
    property Array  options: ["text", "test", "asdf"];
    property Int    selected: 0

    onExtern: {
        meta = OSC::RemoteMetadata.new($remote,
                                       selector.extern)
        #print "selector extern = "
        #puts meta.options
        if(meta.options)
            nopts = []
            meta.options.each do |x|
                nopts << x[1]
            end
            selector.options = nopts
        end
        selector.valueRef = OSC::RemoteParam.new($remote, selector.extern)
        selector.valueRef.mode = :options
        selector.valueRef.callback = Proc.new {|x| selector.set_value(x)}
    }

    function set_value(x)
    {
        self.selected = x
        rt = self.root
        rt.damage_item self if rt
    }

    function layout(l)
    {
        t = widget.class_name.to_sym
        scale = 100
        $vg.font_size scale
        bb = 1
        selector.options.each do |x|
            x = x[0..8] if x.length > 8
            bbl  = $vg.text_bounds(0, 0, x.upcase)
            bb   = [bb, bbl].max
        end
        selfBox = l.genBox t, selector
        if(bb != 0)
            #Width cannot be so small that letters overflow
            l.sh([selfBox.w, selfBox.h], [-1.0, bb/scale], 0)
        end
        selfBox
    }

    function class_name()
    {
        "Selector"
    }

    function onMousePress(ev)
    {
        if(selector.selected  >= (options.length - 1))
            selector.selected = 0
        else
            selector.selected = selector.selected + 1
        end

        self.valueRef.value = self.selected if self.valueRef
        self.root.log(:user_value, self.valueRef.display_value, src=self.label)

        if(selector.root)
            selector.root.damage_item selector
        end
    }

    function draw(vg)
    {
        off_color     = color("424B56")
        outline_color = color("0089b9")
        text_color2   = color("B9CADE")
        pad = 1/64
        vg.path do |v|
            v.rect(w*pad, h*pad, w*(1-2*pad), h*(1-2*pad))
            v.fill_color(off_color)
            #v.stroke_color(outline_color)
            v.fill
            v.stroke_width 1
            v.stroke
        end

        vg.font_face("bold")
        vg.font_size h*0.8
        vg.text_align NVG::ALIGN_CENTER | NVG::ALIGN_MIDDLE
        vg.fill_color text_color2
        vg.text(w/2,h/2,options[selected].upcase)
    }
}
