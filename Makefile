build:
	cd wsl && sudo nix --experimental-features 'nix-command flakes' run .#nixosConfigurations.nixos.config.system.build.tarballBuilder
	mv -f wsl/nixos-wsl.tar.gz nixos-wsl.tar.gz

switch:
	sudo nixos-rebuild switch --flake ./wsl

re-import:
	# powershell
	wsl --unregister NixOS
	wsl --import NixOS "$HOME\NixOS" "nixos-wsl.tar.gz" --version 2
