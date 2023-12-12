{ pkgs, ...}:
{
	let wrapped-discord = pkgs.writeShellScriptBun "discord" ''
		exec ${pkgs.discord}/bin/discord --enable-features=UseOzonePlatform --ozone-platform=wayland
	'' in {
		pkgs.symlinkJoin {
			name = "discord"
			paths = [
				wrapped
				pkgs.discord
			];
		};
	};
}
