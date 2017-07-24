Group {
    id: box
    label: "General"
    property Function whenModified: nil
    property Bool     type: :analog
    property Bool     subsynth: false

    onType: {
        #Changes filter type
    }

    function cb()
    {
        whenModified.call if whenModified
    }

    function change_cat()
    {
        root.change_view()
        if(cat.selected == 1)
            typ.active = false
            typ.damage_self
            return
        end
        dest = self.extern + "Ptype"    if cat.selected == 0
        dest = self.extern + "type-svf" if cat.selected == 2
        if(typ.extern != dest)
            typ.extern = dest
            typ.extern()
        end
        typ.active = true
        typ.damage_self
    }

    function remove_sense() {
        root.ego_death snsa
        root.ego_death snsb
    }

    function move_sense() {
        snsa.extern = path_simp(box.extern + "../PGlobalFilterVelocityScale")
        snsb.extern = path_simp(box.extern + "../PGlobalFilterVelocityScaleFunction")
    }

    ParModuleRow {
        Knob {
            type:      :float
            whenValue: lambda { box.cb};
            extern:    box.extern + "basefreq"
        }
        Knob {
            type:      :float
            whenValue: lambda { box.cb};
            extern:    box.extern + "baseq"
        }
        Knob {
            type:      :float
            whenValue: lambda { box.cb};
            extern:    box.extern + "freqtracking"
        }
        Knob {
            id: snsa;
            extern: {
                ext = "../PFilterVelocityScale"       if !box.subsynth
                ext = "../PGlobalFilterVelocityScale" if  box.subsynth
                path_simp(box.extern + ext)
            }
        }
        Knob {
            id: snsb;
            extern: {
                ext = "../PFilterVelocityScaleFunction"       if !box.subsynth
                ext = "../PGlobalFilterVelocityScaleFunction" if  box.subsynth

                path_simp(box.extern + ext)
            }
        }
    }
    ParModuleRow {
        NumEntry {
            whenValue: lambda { box.cb}
            extern: box.extern + "Pstages"
            offset: 1
            minimum: 1
            maximum: 5
        }
        Selector {
            id: cat
            whenValue: lambda { box.change_cat};
            extern: box.extern + "Pcategory"
        }
        Selector {
            id: typ
            whenValue: lambda { box.cb};
            extern: box.extern + "Ptype"
        }
        Knob {
            type:      :float
            whenValue: lambda { box.cb};
            extern: box.extern + "gain"
        }
    }

    function class_name()
    {
        "ZynAnalogFilter"
    }
}
