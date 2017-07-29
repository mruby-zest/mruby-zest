Group {
    id: box
    label: "General"
    topSize: 0.2
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
        root.change_view()
        dest = self.extern + "Ptype"    if cat.selected == 0
        return                          if cat.selected == 1
        dest = self.extern + "type-svf" if cat.selected == 2
        if(typ.extern != dest)
            typ.extern = dest
            typ.extern()
        end
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

        NumEntry {
            whenValue: lambda { box.cb}
            extern: box.extern + "Pstages"
            offset: 1
            minimum: 1
            maximum: 5
        }
        Selector {
            id: cat
            //whenValue: lambda { box.change_cat};
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
}
