{
    # Prerequisites for screen tearing in 
    # Hyprland.
    #
    # Might need to be deleted when double
    # buffering doesn't suck.
    env = [
        "WLR_DRM_NO_ATOMIC,1"
    ];

    windowrulev2 = [
        "immediate, class:^(cs2)"
    ];
}
