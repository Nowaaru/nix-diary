{
  inputs,
  pkgs,
  lib,
  ...
}: {
  users.users =
    builtins.mapAttrs (k: _: {
      isNormalUser = true;
      description = "user - ${k}";
      shell = pkgs.fish;
      extraGroups = ["networkmanager" "wheel" "libvirtd"];
      packages = []; # managed via home-manager
    })
    (lib.attrsets.filterAttrs (_: v: v == "directory") (builtins.readDir (inputs.self + /usr)));
}
