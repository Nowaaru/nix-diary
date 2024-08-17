{ configure, ... }: {
    programs.starship = {
        settings = configure "starship";
        enable = true;
        enableTransience = true;
        enableFishIntegration = true;
    };
}

