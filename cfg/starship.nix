{
  add_newline = true;
  username = {
    show_always = true;
    format = "[$user]($style)";
    style_user = "bg:bubble_main";
    style_root = "bg:bubble_main";
  };

  character = {
    success_symbol = "[](bold green)";
    error_symbol = "[](bold red)";
    vimcmd_symbol = "[](bold bubble_mountbatten)";
    vimcmd_replace_symbol = "[](bold bubble_red)";
    vimcmd_replace_one_symbol = "[・](bold bubble_mountbatten)";
    vimcmd_visual_symbol = "[󰍉](bold bubble_mountbatten)";
  };

  hostname = {
    ssh_only = false;
    format = "[󰅆 $ssh_symbol$hostname]($style)";
    style = "bg:bubble_maindark";
  };

  directory = {
    format = "[[$path]($style)]($read_only_style)( \\[$read_only\\])($read_only_style)";
    style = "bg:bubble_main bubble_cream";
    read_only = "";
    substitutions = {
      "/" = " · ";
    };
  };

  time = {
    format = "[$time]($style)";
    use_12hr = true;
    style = "bg:bubble_maindark bubble_orange";
    time_format = "%R %p";
    disabled = false;
  };

  palettes = {
    kanagawabones = {
      bubble_main = "#2F2F3D";
      bubble_maindark = "#18181F";

      bubble_red = "#F36461";
      bubble_pearl = "#DDD8BB";
      bubble_orange = "#C57B57";
      bubble_oranger = "#F4743B";
      bubble_tangerine = "#F1AB86";
      bubble_cream = "#C9CF9F";
      bubble_yellow = "#F7DBA7";
      bubble_viridian = "#498467";
      bubble_gray = "#A5ABAF";
      bubble_pink = "#E56399";
      bubble_mountbatten = "#847996";
      bubble_bluedeep = "#7F96FF";
      bubble_bluelight = "#A6CFD5";
      bubble_cyan = "#DBFCFF";
    };
  };

  palette = "kanagawabones";
  # noire in .diary/Config on  master [!+] took 16s
  format = ''
    [](bubble_maindark)[$hostname, at $time](bg:bubble_maindark)[](bubble_maindark)
      [](bubble_main)[$username in $directory](bg:bubble_main)[](bubble_main) $character
  '';
}
