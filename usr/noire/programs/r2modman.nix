{ stable, ... }:
{
	home.packages = with stable; [
		r2modman
	];
}
