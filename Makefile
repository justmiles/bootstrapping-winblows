build:
	cd wsl && sudo /home/sandbox/.nix-profile/bin/nix --experimental-features 'nix-command flakes' run .#nixosConfigurations.nixos.config.system.build.tarballBuilder
	mv wsl/nixos-wsl.tar.gz .