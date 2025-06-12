withSystem: inputs: (final: prev:
{
  # TODO: make this better plz use withSystem with flakeParts easyOverlay and 
  # consume that here plz :sob: 
  inherit (import inputs.nixpkgs-master {inherit (prev) system;}) kdePackages;
})
