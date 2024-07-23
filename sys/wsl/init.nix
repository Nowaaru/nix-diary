{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    home-manager
    pinentry
    gnupg
    git
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-curses;
  };
}
