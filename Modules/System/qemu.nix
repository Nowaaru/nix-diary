{pkgs, ...}: {
  virtualisation.libvirtd.enable = true;
  users.groups.libvirtd.members = ["root" "noire"];

  environment.systemPackages = [
    pkgs.qemu
    pkgs.quickemu
    (pkgs.writeShellScriptBin "qemu-system-x86_64-uefi" ''
      qemu-system-x86_64 \
        -bios ${pkgs.OVMF.fd}/FV/OVMF.fd \
        "$@"
    '')
  ];
}
