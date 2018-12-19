#include <mruby.h>
#include <mruby/variable.h>
#include <mruby/array.h>
#include <mruby/object.h>
#include <math.h>
//def self.normalize(seq)
//    min = 1
//    max = -1
//    seq.each do |x|
//        min = x if x < min
//        max = x if x > max
//    end
//    mag = [max,-min].max
//    mag = 1.0 if mag == 0.0
//    (0...seq.length).each do |i|
//        seq[i] /= mag
//    end
//    seq
//end
static void
normalize(float *f, int n)
{
    float min = 1;
    float max = -1;
    for(int i=0; i<n; ++i) {
        if(f[i] < min)
            min = f[i];
        if(f[i] > max)
            max = f[i];
    }
    float mag = max > -min ? max : -min;
    if(mag == 0)
        mag = 1.0;
    for(int i=0; i<n; ++i)
        f[i] /= mag;
}

float
get(mrb_state *mrb, mrb_value v, const char *field)
{
    mrb_value asdf = mrb_funcall(mrb, v, field, 0);
    if(asdf.tt == MRB_TT_FIXNUM)
        return asdf.value.i;
    else
        return asdf.value.f;
}

//def self.plot(vg, ypts, bb, do_norm=true, phase=0)
//    ypts = DSP::normalize(ypts) if do_norm
//    #xpts = Draw::DSP::linspace(0,1,ypts.length)
//    off = (phase * (ypts.length-1)).to_i
//    vg.path do |v|
//        ypos = bb.y+bb.h/2-bb.h/2*ypts[off]
//        ypos = [bb.y, [ypos, bb.y+bb.h].min].max
//        vg.move_to(bb.x, ypos)
//
//        x_m = bb.w
//        x_b = bb.x
//
//        y_m = -bb.h/2
//        y_b = bb.y+bb.h/2
//        mx = bb.y+bb.h
//        mn = bb.y
//        
//        n = ypts.length
//        (1...n).each do |pt|
//            ii = (off+pt)%n
//            ypos = y_m*ypts[ii] + y_b
//            ypos = mx if ypos > mx
//            ypos = mn if ypos < mn
//            vg.line_to(x_m*pt/n + x_b, ypos)
//        end
//        v.stroke_color Theme::VisualLine
//        v.stroke_width 2.0
//        v.stroke
//    end
//end
mrb_value
draw_oscil_plot(mrb_state *mrb, mrb_value self)
{
    mrb_value vg;
    mrb_value ypts;
    mrb_value bb;
    mrb_value do_norm;
    mrb_float phase;

    mrb_get_args(mrb, "oooof", &vg, &ypts, &bb, &do_norm, &phase);

    int n = mrb_ary_len(mrb, ypts);
    float *f = (float*)mrb_malloc(mrb, n*sizeof(float));
    for(int i=0; i<n; ++i)
        f[i] = mrb_ary_ref(mrb, ypts, i).value.f;

    if(mrb_obj_equal(mrb, mrb_true_value(), do_norm))
        normalize(f, n);

    const float bound_x = get(mrb, bb, "x");
    const float bound_y = get(mrb, bb, "y");
    const float bound_w = get(mrb, bb, "w");
    const float bound_h = get(mrb, bb, "h");

    int off = phase * (n-1);

    const int min_y = bound_y;
    const int max_y = bound_y + bound_h;

    int ii = off%n;
    float ypos = -bound_h/2*f[ii] + bound_y+bound_h/2.0;
    if(ypos > max_y) ypos = max_y;
    if(ypos < min_y) ypos = min_y;

    mrb_funcall(mrb, vg, "begin_path", 0);
    
    mrb_funcall(mrb, vg, "move_to", 2,
            mrb_float_value(mrb, bound_x),
            mrb_float_value(mrb, ypos));

    for(int i=1; i<n; ++i) {
        ii = (off+i)%n;
        ypos = -bound_h/2*f[ii] + bound_y+bound_h/2.0;
        if(ypos > max_y) ypos = max_y;
        if(ypos < min_y) ypos = min_y;

        mrb_funcall(mrb, vg, "line_to", 2,
                mrb_float_value(mrb, bound_w*ii/n + bound_x),
                mrb_float_value(mrb, ypos));
    }
    mrb_value theme     = mrb_vm_const_get(mrb, mrb_intern_cstr(mrb, "Theme"));
    mrb_value linecolor = mrb_const_get(mrb, theme, mrb_intern_cstr(mrb, "VisualLine"));
    mrb_funcall(mrb, vg, "stroke_color", 1, linecolor);
    mrb_funcall(mrb, vg, "stroke_width", 1, mrb_float_value(mrb, 2.0));
    mrb_funcall(mrb, vg, "stroke", 0);
    mrb_funcall(mrb, vg, "close_path", 0);

    mrb_free(mrb, f);
    return self;
}

//def self.norm_harmonics(seq)
//    (0...seq.length).each do |i|
//        seq[i] = -seq[i] if seq[i] < 0
//    end
//    max = -1
//    seq.each do |x|
//        max = x if x > max
//    end
//    (0...seq.length).each do |i|
//        seq[i] = (seq[i]/max)**0.1
//    end
//    seq
//end
static mrb_value
norm_harmonics(mrb_state *mrb, mrb_value self)
{
    mrb_value ary;
    mrb_get_args(mrb, "o", &ary);
    int n = mrb_ary_len(mrb, ary);
    float *f = (float*)mrb_malloc(mrb, n*sizeof(float));
    for(int i=0; i<n; ++i)
        f[i] = mrb_ary_ref(mrb, ary, i).value.f;

    float max = -1.0;
    for(int i=0; i<n; ++i) {
        if(f[i] < 0)
            f[i] *= -1;
        if(f[i] > max)
            max = f[i];
    }

    for(int i=0; i<n; ++i)
        mrb_ary_set(mrb, ary, i,
                mrb_float_value(mrb, powf(f[i]/max, 0.1)));
    return ary;
}

//def self.bar(vg, data, bb, bar_color, xx=nil)
//    n    = data.length
//    xpts = Draw::DSP::linspace(0,1,n)
//    bx   = bb.x
//    bw   = bb.w
//    by   = bb.y
//    bh   = bb.h 
//
//    y  = by+bh
//
//    vg.stroke_color bar_color
//    vg.stroke_width 1.0
//    (0...n).each do |i|
//        x  = bx + xpts[i]*bw      if !xx
//        x  = bx + xx[i]  *bw/64.0 if  xx
//        vg.path do
//            vg.move_to(x, y)
//            vg.line_to(x, y-bh*data[i])
//            vg.stroke
//        end
//    end
//end
static mrb_value
bar(mrb_state *mrb, mrb_value self)
{
    mrb_value vg;
    mrb_value ypts;
    mrb_value bb;
    mrb_value color;
    mrb_value xx;

    mrb_get_args(mrb, "ooooo", &vg, &ypts, &bb, &color, &xx);

    int n = mrb_ary_len(mrb, ypts);
    float *f = (float*)mrb_malloc(mrb, n*sizeof(float));
    for(int i=0; i<n; ++i)
        f[i] = mrb_ary_ref(mrb, ypts, i).value.f;

    const float bound_x = get(mrb, bb, "x");
    const float bound_y = get(mrb, bb, "y");
    const float bound_w = get(mrb, bb, "w");
    const float bound_h = get(mrb, bb, "h");

    const float y  = round(bound_y+bound_h);
    mrb_funcall(mrb, vg, "stroke_color", 1, color);
    mrb_funcall(mrb, vg, "stroke_width", 1, mrb_float_value(mrb, 1.0));

    mrb_funcall(mrb, vg, "translate", 2,
        mrb_float_value(mrb, 0.5f),
        mrb_float_value(mrb, 0.5f));

    for(int i=0; i<n; ++i)
    {
        float x;
        if(mrb_obj_equal(mrb, mrb_nil_value(), xx)) {
            x = bound_x + i*1.0/(n-1)*bound_w;
        } else {
            x = bound_x + mrb_ary_ref(mrb, xx, i).value.f*bound_w/64.0;
        }

        x = round(x);

        const int target_y = round(y-bound_h*f[i]);

        mrb_funcall(mrb, vg, "begin_path", 0);
        mrb_funcall(mrb, vg, "move_to", 2,
                mrb_float_value(mrb, x),
                mrb_float_value(mrb, y));
        mrb_funcall(mrb, vg, "line_to", 2,
                mrb_float_value(mrb, x),
                mrb_float_value(mrb, target_y));
        mrb_funcall(mrb, vg, "stroke", 0);
        mrb_funcall(mrb, vg, "close_path", 0);
    }

    mrb_funcall(mrb, vg, "translate", 2,
            mrb_float_value(mrb, -0.5f),
            mrb_float_value(mrb, -0.5f));

    mrb_free(mrb, f);
    return self;
}

void
mrb_mruby_zest_gem_init(mrb_state *mrb) {
    struct RClass *module = mrb_define_module(mrb, "Draw");
    mrb_define_class_method(mrb, module, "opt_plot", draw_oscil_plot, MRB_ARGS_REQ(5));
    mrb_define_class_method(mrb, module, "opt_norm_harmonics", norm_harmonics, MRB_ARGS_REQ(1));
    mrb_define_class_method(mrb, module, "opt_bar", bar, MRB_ARGS_REQ(5));
}
void
mrb_mruby_zest_gem_final(mrb_state* mrb) {
}
