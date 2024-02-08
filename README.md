# Windows Bootstrapping

Bootstrap your Windows desktop like a boss.

## Quick Steps

1. Launch Powershell as an admin to run the `admin_*.ps1` files in the `powershell_scripts` directory. These scripts:

- install the majority of end-user desktop software
- remove some bloatware
- install WSL

2. Launch Powershell as a normal user to run the remaining `uininstall_bloatware.ps1` script. This script:

- Removes the majority of anti-features Windows provides

3. You can certainly build your own NixOS WSL distribution but to get started quickly you can also import my pre-built tarball.

- Download this pre-built NixOS installation and import it into a WSL distirbution called "NixOS"

  ```powershell
  wsl --import NixOS "$HOME\NixOS" "$HOME\Downloads\nixos-wsl.tar.gz" --version 2
  ```

- Launch NixOS

  ```powershell
  wsl --distribution NixOS
  ```

## Building your own NixOS WSL distribution

## TODOs

- check for and install all updates
