Widget {
    Macro {
        id: spawn
        field: "off"
        value: [0,1,2,3,4]
        property Object dep: [:zero, :one, :two, :three, :four]


        Widget {
            id: k$off
            property Object value: $off;
            property Object dependent: spawn.dep[k$off.value]

            function class_name() {
                "macro_sub$off"
            }

            function to_s() {
                "<"+class_name() + ":" + dependent.to_s + ">"
            }
        }
    }
}
