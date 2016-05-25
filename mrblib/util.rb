def border(scale, pos)
    pos[0] += scale;
    pos[1] += scale;
    pos[2] -= 2*scale;
    pos[3] -= 2*scale;
end

def pad(scale, bb)
    cx = bb[0] + bb[2]/2.0;
    cy = bb[1] + bb[3]/2.0;
    w  = bb[2]*scale;
    h  = bb[3]*scale;
    bb[0] = cx - w/2.0;
    bb[1] = cy - h/2.0;
    bb[2] = w;
    bb[3] = h;
end

def color(c)
    r = c[0..1].to_i 16
    g = c[2..3].to_i 16
    b = c[4..5].to_i 16
    a = 255
    NVG.rgba(r,g,b,a)
end
