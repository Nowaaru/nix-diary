{pkgs, ...}: {
  # point at your Pi as an aarch64 builder
  nix.buildMachines = [
    {
      hostName = "192.168.0.165"; # your Pi’s hostname or IP
      sshUser = "blanc";

      protocol = "ssh-ng";
      system = "aarch64-linux";

      maxJobs = 2; # Pi is slower—don’t swamp it!
      speedFactor = 10; # weights scheduling

      supportedFeatures = []; # leave empty for vanilla builds
    }
  ];

  nix.distributedBuilds = true;

  environment.systemPackages = with pkgs; [
    gcc
  ];
}
