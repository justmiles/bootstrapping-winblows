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

4. Use the shell or open http://localhost:3000 for an integrated development environment

## Building your own NixOS WSL distribution

Check out these resources:

- https://github.com/LGUG2Z/nixos-wsl-starter
- https://github.com/mitchellh/nixos-config?tab=readme-ov-file#setup-wsl
- https://github.com/nix-community/NixOS-WSL

## Why does this repo exist?

This repo outlines my dev migration from Linux to Windows. While I aim for it to be technical in nature, my natural spite for development on Windows is bound to trickle through. Don't take it to heart. Great people have done great things at the Windows "power" shell.

Fuck Windows.

I have been a dedicated user of Linux Mint since 2006, relying on it for both personal and work machines. When it comes to servers, I have preferred Ubuntu Server. However, over the past year, I have discovered the value of the Nix ecosystem, which completely replaces traditional configuration management tools like Chef, Ansible, and Puppet with its fully declarative operating system. I have since started moving my personal servers from Ubuntu to NixOS and have been thoroughly enjoying the experience.

Unfortunately, recent changes in my work environment have forced me to replace Linux Mint with Windows as my daily driver. While this decision warrants a discussion on supporting innovative developers in their preferred environment, for now, I will focus on adapting to this inevitable change.

So, how can I make the best of using Windows? By installing Linux!

The Windows Subsystem for Linux (WSL) may not be perfect, but it allows us to run Linux within the Windows environment. Although it is slower, requires more resources, and features an ad-filled desktop environment called "Windows Shell," it still provides the Linux functionality we need. To enhance this experience, I recommend using Nix in the WSL. Yes, you can create a root tarball using Nix and then import it into WSL.

By following this approach, you can have your entire Nix environment available on Windows, effectively transferring your codified setup.

## TODOs

- check for and install all Windows updates
- provide instructions for making changes
