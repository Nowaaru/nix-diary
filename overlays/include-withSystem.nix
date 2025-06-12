withSystem: (_: super: {
  lib = super.lib.extend (_: _:
    {
      inherit withSystem;
    });
})
