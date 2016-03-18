import QtQuick 2.0
import ZynAddSubFX 1.0
import "qrc:/qml/"

Valuator {
    id: slider

    function class_name()
    {
        "Slider"
    }

    function layout(l)
    {
        t = widget.class_name.to_sym
        selfBox = l.genBox t, widget
        l.aspect(selfBox, 4, 1)
        selfBox
    }

    function draw(vg)
    {
        w = slider.w
        h = slider.h
        norm_value = slider.norm_value
        vg.draw(w,h,1.0) do |vg|
            vg.path do |v|
                v.rect(w/4, h/4+(1-norm_value)*h/2, w/2, norm_value*h/2)
                #v.rect(0, 1-norm_value)*h, w, norm_value*h)
                #puts("rect(#{w/4},#{h/4},#{w/2},#{h/2})")
                v.fill_color(NVG.rgba(128, 0, 0, 255))
                v.fill
            end
        end
    }
}

