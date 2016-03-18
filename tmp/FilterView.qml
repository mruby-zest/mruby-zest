import QtQuick 2.2
import ZynAddSubFX 1.0
import "qrc:/qml/"

Widget {
    layoutOpts: [:vertical]
    Module {
        label: "filter"
        Knob {
            label: "c.freq"
        }
        Knob {
            label: "q"
        }
        Knob {
            label: "v.sns a."
        }
        Knob {
            label: "freq.tr"
        }
        Knob {
            label: "gain"
        }
        DropDown {
            label: "st"
            text:  "2x"
        }
        DropDown {
            label: "category"
            text:  "analog"
        }
        DropDown {
            label: "f.type"
            text:  "lpf2"
        }
    }
    Module {
        label: "filter envelope"
        copyable: true
        editable: true
        Repeater {
            model: ["a.val", "a.dt", "d.val",
            "d.dt", "r.dt", "r.val", "stretch"]
            Knob { label: modelData }
        }
        Button {
            label: "frcr"
        }
    }
}

