{ pkgs, ... }:
{
    
	home.file = {
		".config/vinegar/config.toml".text = ''
        sanitize_env = true

        [env]
        WINEESYNC = "1"
		[splash]
		style = "familiar"
        [studio]
        dxvk = false
        renderer = "D3D11FL10"
        launcher = "gamemoderun"
		'';
	};

	home.packages = with pkgs; [
		vinegar
        rojo
	];
}
