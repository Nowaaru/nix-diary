{lib}:
with (import ./util.nix {inherit lib;}).keys; [
  (nmap "j" "gj")
  (nmap "k" "gk")
]
