withSystem: (_: super: {
  lib = super.lib.extend (_: prev:
    prev
    // {
      inherit withSystem;
    });
})
