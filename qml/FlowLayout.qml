Object {
    id: this

    function bound_child(l, c)
    {
        p  = this
        ch = c
        l.let(:pw, p.w, :ph, p.h,
              :x, c.x, :y, c.y, :w, c.w, :h, c.h) do
            l.c(:x, :w, :<, :pw)
            l.c(:y, :h, :<, :ph)
        end
    }


    function layout(l)
    {
        if(l.parent)
            bound_parent(l)
        end
    }
}
