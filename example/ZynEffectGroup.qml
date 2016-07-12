//Scrollable container for Zyn effects

//Vertically packs effects according to type
//each type is either 1U, 2U, or 3U and gets space accordingly
//either a whole effect can fit on the screen or a series of 1U
//placeholders are put in its place

Widget {
    property Int   nunits: 6
    property Int   offset: 0
    property Array effects: []
    property Int   maxeffects: 8


    function get_units(type)
    {
        mapper = {"Alienwah" => 1,
                  "Chorus" => 1,
                  "Distorsion" => 1,
                  "DynamicFilter" => 3,
                  "EQ" => 2,
                  "Echo" => 1,
                  "Phaser" => 1,
                  "Reverb" => 1}
    }

    function layout(l)
    {
        selfBox = l.genBox :eff, self
    }
}
