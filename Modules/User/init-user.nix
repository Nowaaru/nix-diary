{ config, pkgs, lib, ...}: 
let 
	import-list = lib.filterAttrs (path: path != "init-user.nix") (lib.importDir { inherit (lib) importDir; dir = ./.; });
in
{
	imports = import-list;
}
