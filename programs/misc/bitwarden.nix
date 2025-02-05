{withSystem, ...}:
withSystem "x86_64-linux" ({self', ...}: {
  home.packages = with self'.legacyPackages.stable; [
    bitwarden
  ];
})
