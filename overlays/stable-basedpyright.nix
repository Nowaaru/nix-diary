withSystem: inputs: (
  _: prev:
  # withSystem prev.system ({self', ...}: {
  #   inherit (self'.legacyPackages.stable) basedpyright;
  # })
  {
    # basedpyright because nvf configuration
    # currently errors
    inherit
      (import inputs.nixpkgs-mirror {
        inherit (prev) system;
      })
      basedpyright
      lldb
      ;
  }
)
