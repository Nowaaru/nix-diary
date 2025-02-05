{
  inputs,
  configure,
  ...
}: {
  imports = [
    inputs.nvf.homeManagerModules.default
  ];

  programs = {
    nvf = {
      enable = true;
      settings = {};
    };
  };
}
