withSystem:  
{home-manager, self, ...} @ inputs: (_: super: {
  lib = super.lib.extend (_: prev:
    # home-manager.lib //
      prev
      // {
        # add lib.hm to my lib
        inherit (home-manager.lib) hm;

        # add lib.nnmm to lib
        inherit (inputs.nix-mod-manager.lib) nnmm;
        inherit withSystem;

        gamindustri = import (self + /lib) (inputs
          // {
            pkgs = super;
            lib =
              prev
              // home-manager.lib
              // {  inherit withSystem; }
              // (
                if super ? "config" && super.config ? "lib"
                then builtins.trace "has config.lib" super.config.lib
                else {}
              );
          });
          
      });
  # override with
})
