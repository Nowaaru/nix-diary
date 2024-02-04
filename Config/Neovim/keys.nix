{lib}:
with (import ./util.nix {inherit lib;}).keys; [
  (nnoremap "j" "gj")
  (nnoremap "k" "gk")
]
