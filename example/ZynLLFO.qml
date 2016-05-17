ParModule {
    w: 500*4
    h: 300*4
    extern: "/part0/kit0/adpars/GlobalPar/FreqLfo/"
    label:  "generic lfo"
    id:    lfo_mod
    Knob     {extern: lfo_mod.extern+"Pfreq"}
    Knob     {extern: lfo_mod.extern+"Pintensity"}
    Knob     {extern: lfo_mod.extern+"Pstartphase"}
    Knob     {extern: lfo_mod.extern+"Pstretch"}
    Knob     {extern: lfo_mod.extern+"Prandomness"}
    Knob     {extern: lfo_mod.extern+"Pfreqrand"}
    Selector {extern: lfo_mod.extern+"PLFOtype"}
    Button   {extern: lfo_mod.extern+"Pcontinous"; label: "C"}
}
//
//onExtern
//_handle = $schema.get self.extern
//label   = _handle.shortname
//tooltip = _handle.tooltip
//$bridge.map(self.extern, self.value, 0.0, 1.0)
//
//extra for dropdown
//options         = _handle.options
//options_mapping = _handle.options_mapping
