{lib}:
with lib; {
  user = {
    signingkey = "~/.ssh/id_ed25519";
    email = mkForce "nowaaru@proton.me";
    name = mkForce "Nowaaru";
  };

  commit.gpgsign = true;
}
