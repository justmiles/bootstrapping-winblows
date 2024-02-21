# Windows Bootstrapping

Bootstrap your Windows desktop like a boss.

## Quick Steps

1. Launch Powershell as an admin to run the `admin_*.ps1` files in the `powershell_scripts` directory. These scripts:

    - install the majority of end-user desktop software
    - remove some bloatware
    - install WSL

2. Launch Powershell as a normal user to run the remaining `uininstall_bloatware.ps1` script. This script:

    - Removes the majority of anti-features Windows provides

3. Let's start on the NixOS install. Download this pre-built NixOS installation and import it into a WSL distirbution called "NixOS"
    
    ```powershell
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    (New-Object System.Net.WebClient).DownloadFile("https://github.com/nix-community/NixOS-WSL/releases/download/2311.5.3/nixos-wsl.tar.gz", "$HOME\Downloads\nixos-wsl.tar.gz")

    # Import NixOS
    wsl --import NixOS "$HOME\NixOS" "$HOME\Downloads\nixos-wsl.tar.gz" --version 2

    # Create a "workspaces" folder to persist your working documents outside of WSL
    wsl -d NixOS /run/current-system/sw/bin/mkdir -p "/mnt/c/Users/$env:USERNAME/Documents/workspaces"
    wsl -d NixOS /run/current-system/sw/bin/ln -s "/mnt/c/Users/$env:USERNAME/Documents/workspaces" "/home/nixos/workspaces"
    
    # Launch NixOS
    wsl --distribution NixOS
    ```

5. From inside of WSL, update channels

    ```bash
    sudo nix-channel --update
    ```

6. Clone this repo
    
    ```bash
    cd ~/workspaces
    nix-shell -p git
    git clone https://github.com/justmiles/bootstrapping-winblows.git
    cd bootstrapping-winblows
    ```

7. Update `wsl/flake.nix` to set your username 

    ```bash
    grep "username =" wsl/flake.nix
    vi wsl/flake.nix
    ```

8. Rebuild using the latest

    ```bash
    sudo nixos-rebuild switch --flake ./wsl
    ```

9. Use the `wsl -d NixOS` to launch the shell or open http://localhost:3000 for an integrated development environment

10. Fork this repo and start making changes to build out your own environment.

    - check out https://search.nixos.org for packages and flakes

## Building your own NixOS WSL distribution

Check out these resources:

- https://github.com/nix-community/NixOS-WSL
- https://github.com/LGUG2Z/nixos-wsl-starter
- https://github.com/mitchellh/nixos-config?tab=readme-ov-file#setup-wsl

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
