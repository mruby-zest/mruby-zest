Widget {
    function onSetup(old=nil)
    {
        (0...32).each do |ev|
            hm = Qml::HarmonicEditSingle.new(db)
            hm.pad = 0.03
            hm.label = ev.to_s
            Qml::add_child(self, hm)
        end
    }
    function layout(l)
    {
        selfBox = l.genBox :harmonicEdit, self

        n = children.length
        children.each_with_index do |ch, id|
            box = ch.layout(l)
            l.fixed(box, selfBox, id/n, 0, 1.0/n, 1.0)
        end

        selfBox
    }
    function draw(vg)
    {
        return
        vg.path do |v|
            v.rect(0,0,self.w,self.h)
            v.fill_color color("ff600f")
            v.fill
        end
    }
}
