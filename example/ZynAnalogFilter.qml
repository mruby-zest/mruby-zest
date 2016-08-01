Group {
    id: box
    label: "General"
    property Function whenModified: nil
    property Bool     type: :analog

    onType: {
        #Changes filter type
    }

    function cb()
    {
        whenModified.call if whenModified
    }

    function change_cat()
    {
        dest = self.extern + "Ptype"    if cat.selected == 0
        return                          if cat.selected == 1
        dest = self.extern + "type-svf" if cat.selected == 2
        if(typ.extern != dest)
            typ.extern = dest
            typ.extern()
        end
    }

    function remove_sense() {
        root.ego_death snsa
        root.ego_death snsb
    }

    ParModuleRow {
        Knob { whenValue: lambda { box.cb};  extern: box.extern     + "Pfreq" }
        Knob { whenValue: lambda { box.cb};  extern: box.extern     + "Pq" }
        Knob { whenValue: lambda { box.cb};  extern: box.extern     + "Pfreqtrack" }
        Knob { id: snsa; extern: path_simp(box.extern + "../PFilterVelocityScale") }
        Knob { id: snsb; extern: path_simp(box.extern + "../PFilterVelocityScaleFunction") }
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
        Knob { whenValue: lambda { box.cb};  extern: box.extern     + "Pgain" }
    }
}
