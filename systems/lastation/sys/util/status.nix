{ stable, ... }:
{
  environment.systemPackages = with stable; [
		nvtopPackages.full
		htop
  ];
}
