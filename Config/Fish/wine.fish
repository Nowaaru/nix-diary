
function set_wine -a arch_str
	set wine_colored $(set_color 662d3d; printf "\udb82\udc76 Wine"; set_color normal);
	set wine "arch";
	switch (string lower $arch_str)
		case "win32" "32"
			begin
				set arch 32
				echo "$(set_color green; printf "\uf00c") $wine_colored architecture has been set to win32.";
			end
		case "win64" "64"
			begin
				set arch 64
				echo "$(set_color green; printf "\uf00c") $wine_colored architecture has been set to win64.";
			end
		case "*"
			begin
				echo "$(set_color red; printf "uf467") $wine_colored architecture \'$argv[1]\' does not exist."
				return 1;
			end
	end

	set -Ux WINEARCH win$arch;
	set -Ux WINEPREFIX ~/.wine$arch;
	alias wine="command wine$arch";

	return 0;
end
alias wine32="set_wine win32; command wine"
alias wine64="set_wine win64; command wine"
