Object {
    id: theme
    const Color global_dim:       color("#114575")
    const Color global_bright:    color("#3ac5ec")


    const Color env_background:   color("#808080")
    const Color env_fill_color:   color("#0d0d0d")
    const Color env_stroke_color: color("#014767")
    const Color env_light_fill:   color("#114575", 55)
    const Color env_bright:       theme.global_bright
    const Color env_dim:          theme.global_dim
    const Color env_sel:          color("#00ff00")

    const Color knob_bright:      theme.global_bright
    const Color knob_dim:         theme.global_dim

    const Color button_on:        color("#00ff00")
    const Color button_off:       color("#04375e")
    const Color button_outline:   color("#0089b9")
    const Color button_text1:     color("#00c2ea")
    const Color button_text2:     color("#00c2ea")

    const Color dropdown_color:   color("#000080")

    function color(x, alpha=255)
    {
        nil
    }

}
