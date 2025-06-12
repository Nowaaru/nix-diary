withSystem: inputs: (final: prev: rec {
  wayland-protocols = prev.callPackage (inputs.self + /packages/wayland-protocols.nix) {};
  kdePackages =
    prev.kdePackages
    // {
      inherit wayland-protocols;
    };
})
