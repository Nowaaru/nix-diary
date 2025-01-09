{inputs, ...}: {
  inherit (inputs.nixgl) packages;
  vulkan.enable = true;

  # also include mesaPrime just-in-case
  # nvidiaPrime's OpenGL sucks asscheeks
  installScripts = ["mesa" "nvidiaPrime" "mesaPrime"];

  prime = {
    card = "pci-0000_09_00_0";
    installScript = "nvidia"; # use nvidia graphics library
  };

  offloadWrapper = "nvidiaPrime"; # want to offload to nvidia card
  defaultWrapper = "mesa";
}
