{configure, pkgs, ...}: {
  # home.packages = with pkgs; [ 
  #   nixgl.auto.nixGLDefault
  #   nixgl.auto.nixVulkanNvidia
  # ];

  nixGL = configure "nixgl";
}
