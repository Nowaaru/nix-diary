{lib}:
with (import ./util.nix {inherit lib;}).keys; [
  (nnoremap "j" "gj")
  (nnoremap "k" "gk")
]
/*
gk/gj test

with (import ./util.nix {inherit lib;}).keys; with (import ./util.nix {inherit lib;}).keys; with (import ./util.nix {inherit lib;}).keys; with (import ./util.nix {inherit lib;}).keys; with (import ./util.nix {inheritlib;}).keys;
*/

