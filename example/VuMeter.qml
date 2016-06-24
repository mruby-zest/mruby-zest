Widget {
    function draw(vg)
    {
        indent_color = Theme::VisualBackground
        background indent_color

        bar_color = Theme::VisualLine
        pad = 3
        vg.path do |v|
            v.rect(pad,0.3*h, 0.2*w, 0.7*h-pad)
            v.fill_color bar_color
            v.fill
        end
        
        vg.path do |v|
            v.rect(0.8*w-pad,0.5*h, 0.2*w, 0.5*h-pad)
            v.fill_color bar_color
            v.fill
        end
    }
}
