{pkgs, ...}: {
  home.packages = with pkgs; [
    # (blender.override {
    #   cudaSupport = true;
    #   hipSupport = true;
    #   jackaudioSupport = true;
    #   colladaSupport = true;
    # })
  ];
}
