
module Draw
    module WaveForm
        def self.sin(vg, bb, pts=128)
            xpts = Draw::DSP::linspace(0,1,pts)
            vg.path do |v|
                vg.move_to(bb.x, bb.y+bb.h/2)
                (1...pts).each do |pt|
                    vg.line_to(bb.x+bb.w*xpts[pt],
                               bb.y+bb.h/2+bb.h/2*Math.sin(2*3.14*xpts[pt]))
                end
                v.stroke_color color("4195a5")
                v.stroke
            end
        end

        def self.plot(vg, ypts, bb, do_norm=true)
            ypts = DSP::normalize(ypts) if do_norm
            xpts = Draw::DSP::linspace(0,1,ypts.length)
            vg.path do |v|
                vg.move_to(bb.x, bb.y+bb.h/2-bb.h/2*ypts[0])
                (1...ypts.length).each do |pt|
                    vg.line_to(bb.x+bb.w*xpts[pt],
                               bb.y+bb.h/2-bb.h/2*ypts[pt])
                end
                v.stroke_color color("4195a5")
                v.stroke_width 2.0
                v.stroke
            end
        end

        def self.bar(vg, data, bb, bar_color)
            n    = data.length
            xpts = Draw::DSP::linspace(0,1,n)
            (0...n).each do |i|
                x = bb.x+xpts[i]*bb.w
                y = bb.y+bb.h
                vg.path do |v|
                    v.move_to(x, y)
                    v.line_to(x, y-bb.h*data[i])
                    v.stroke_color bar_color
                    v.stroke_width 1.0
                    v.stroke
                end
            end

        end
    end
    module Grid
        def self.log_y(vg, min, max, bb)
            med_fill     = color("114575")
            log10 = Math.log(10)
            min_  = Math.log(min)/log10
            max_  = Math.log(max)/log10
            #1,2,3,4,5,6,7,8,9,10,20
            xx = min_.to_i
            loop {
                break if xx>max_
                base = (xx-min_)/(max_-min_)

                (0...10).each do |shift|
                    delta = Math.log((shift+1)*1.0)/(log10*(max_-min_))
                    dy = bb.h*(base+delta);

                    next if(dy < 0 || dy > bb.h)
                    vg.path do |v|
                        v.move_to(bb.x,      bb.y+dy);
                        v.line_to(bb.x+bb.w, bb.y+dy);
                        v.stroke_color med_fill
                        v.stroke
                    end
                end
                xx += 1
            }
        end
        def self.log_x(vg, min, max, bb)
            med_fill     = color("114575")
            log10 = Math.log(10)
            min_  = Math.log(min)/log10
            max_  = Math.log(max)/log10
            #1,2,3,4,5,6,7,8,9,10,20
            xx = min_.to_i
            loop {
                break if xx>max_
                base = (xx-min_)/(max_-min_)

                (0...10).each do |shift|
                    delta = Math.log((shift+1)*1.0)/(log10*(max_-min_))
                    dx = bb.w*(base+delta);

                    next if(dx < 0 || dx > bb.w)
                    vg.path do |v|
                        v.move_to(bb.x+dx, bb.y);
                        v.line_to(bb.x+dx, bb.y+bb.w);
                        v.stroke_color med_fill
                        v.stroke_width 2
                        v.stroke
                    end
                end
                xx += 1
            }
        end
        def self.linear_x(vg, min, max, bb, thick=1.0)
            med_fill     = color("114575")
            light_fill   = color("114575")
            c = 40
            (0..c).each do |ln|
                vg.path do |v|
                    off = (ln/c)*(bb.w)
                    vg.move_to(bb.x+off, bb.y)
                    vg.line_to(bb.x+off, bb.y+bb.h)
                    if((ln%10) == 0)
                        v.stroke_color med_fill
                        v.stroke_width 4.0*thick
                    else
                        v.stroke_color light_fill
                        v.stroke_width 2.0*thick
                    end
                    v.stroke
                end
            end
        end
        def self.linear_y(vg, min, max, bb, thick=1.0)
            med_fill     = color("114575")
            light_fill   = color("114575")
            c = 40
            (0..c).each do |ln|
                vg.path do |v|
                    off = (ln/c)*(bb.h)
                    vg.move_to(bb.x,      bb.y+off)
                    vg.line_to(bb.x+bb.w, bb.y+off)
                    if((ln%10) == 0)
                        v.stroke_color med_fill
                        v.stroke_width 4.0*thick
                    else
                        v.stroke_color light_fill
                        v.stroke_width 2.0*thick
                    end
                    v.stroke
                end
            end
        end
    end

    module DSP
        PI = 3.14

        #try to get a -1..1 signal
        def self.normalize(seq)
            min = 1
            max = -1
            seq.each do |x|
                min = x if x < min
                max = x if x > max
            end
            mag = [max,-min].max
            (0...seq.length).each do |i|
                seq[i] /= mag
            end
            seq
        end

        def self.norm_harmonics(seq)
            (0...seq.length).each do |i|
                seq[i] = -seq[i] if seq[i] < 0
            end
            max = -1
            seq.each do |x|
                max = x if x > max
            end
            (0...seq.length).each do |i|
                seq[i] = (seq[i]/max)**0.1
            end
            seq
        end

        def self.magnitude(num, dem, freq, order=1)
            angle = PI*freq
            n = Complex(0,0)
            d = Complex(1,0)
            (0...num.length).each do |i|
                n += Complex.polar(num[i], i*angle)
                d -= Complex.polar(dem[i], i*angle)
            end
            (n/d).abs**order
        end

        def self.logspace(a,b,n)
            la = Math.log10(a)
            lb = Math.log10(b)
            out = []
            (0...n).each do |i|
                out << 10**(la + i/n*(lb-la))
            end
            out
        end

        def self.linspace(a,b,n)
            out = []
            (0...n).each do |i|
                out << a + i/n*(b-a)
            end
            out
        end

        def self.cumsum(x)
            partial = 0
            n       = x.length
            (0...n).each do |i|
                partial += x[i]
                x[i]     = partial
            end
            x
        end

        def self.ary_max(x)
            max = -1
            x.each do |xx|
                max = xx if xx>max
            end
            max
        end

        def self.norm_0_1(x)
            max = ary_max(x)
            n   = x.length
            (0...n).each do |i|
                x[i] /= max
            end
            x
        end
    end
    module Layout
        def self.vpack(l, selfBox, b, x=0, w=1)
            off = 0
            n = b.length
            b.each_with_index do |bb,i|
                l.fixed(bb, selfBox, x, off, w,  1.0/n)
                off += 1.0/n
            end
            selfBox
        end

        def self.hpack(l, selfBox, b)
            off = 0
            n = b.length
            b.each_with_index do |bb,i|
                l.fixed(bb, selfBox, off, 0, 1.0/n, 1.0)
                off += 1.0/n
            end
            selfBox
        end

        def self.hfill(l, selfBox, b, w)
            off = 0
            b.each_with_index do |bb,i|
                l.fixed(bb, selfBox, off, 0, w[i], 1)
                off += w[i]
            end
            selfBox
        end

        def self.vfill(l, selfBox, b, h)
            off = 0
            b.each_with_index do |bb,i|
                l.fixed(bb, selfBox, 0, off, 1,  h[i])
                off += h[i]
            end
            selfBox
        end
    end

    def self.fade(c)
        cc = c.clone
        cc.a = 0.8
        cc
    end
end

def color(c)
    if(c.class == Symbol)
        if(c == :red)
            return color("ff0000")
        elsif(c == :blue)
            return color("00ff00")
        elsif(c == :green)
            return color("0000ff")
        elsif(c == :coral)
            return color("FF7F50")
        elsif(c == :dark_orange)
            return color("FF8C00")
        elsif(c == :gold)
            return color("FFD700")
        else
            raise Exception.new("Invalid Color", c)
        end
    end
    r = c[0..1].to_i 16
    g = c[2..3].to_i 16
    b = c[4..5].to_i 16
    a = 255
    NVG.rgba(r,g,b,a)
end

module Theme
    VisualBackground    = color("232C36")
    GeneralBackground   = color("334454")
    SliderActive        = color("032E4E")
    HarmonicColor       = color("026392")

    TextColor           = color("B9CADE")
    
    ScrollInactive      = color("06354B")
    ScrollActive        = color("007C93")
    TitleBar            = color("042E4D")
    ButtonInactive      = color("424B56")
    ButtonActive        = color("00818E")
end

#Draw a linear x/y grid
def draw_grid(vg, r, c, x, w, h)
    light_fill   = NVG.rgba(0x11,0x45,0x75,200)
    med_fill   = NVG.rgba(0x11,0x45,0x75,240)

    h = lfo_vis.h

    (1..r).each do |ln|
        vg.path do |v|
            off = (ln/r)*(h/2)
            vg.move_to(x, h/2+off);
            vg.line_to(x+w, h/2+off)
            vg.move_to(x, h/2-off);
            vg.line_to(x+w, h/2-off)
            if((ln%10) == 0)
                v.stroke_color med_fill
                v.stroke_width 2.0
            else
                v.stroke_color light_fill
                v.stroke_width 1.0
            end
            v.stroke
        end
    end

    (1..c).each do |ln|
        vg.path do |v|
            off = (ln/c)*(w)
            vg.move_to(x+off, 0)
            vg.line_to(x+off, h)
            if((ln%10) == 0)
                v.stroke_color med_fill
                v.stroke_width 2.0
            else
                v.stroke_color light_fill
                v.stroke_width 1.0
            end
            v.stroke
        end
    end
end
