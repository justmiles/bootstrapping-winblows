{ username
, hostname
, pkgs
, inputs
, ...
}:
let
  code-server = (pkgs.callPackage ../modules/code-server.nix { });
in
{
  time.timeZone = "America/Chicago";

  networking.hostName = "${hostname}";

  systemd.tmpfiles.rules = [
    "d /home/${username}/.config 0755 ${username} users"
    "d /home/${username}/.config/lvim 0755 ${username} users"
  ];

  programs.zsh.enable = true;
  environment.pathsToLink = [ "/share/zsh" ];
  environment.shells = [ pkgs.zsh ];

  environment.enableAllTerminfo = true;

  security.sudo.wheelNeedsPassword = false;

  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "docker"
      "mlocate"
    ];
  };

  environment.systemPackages = [
    (import ./win32yank.nix { inherit pkgs; })
    code-server
  ];

  home-manager.users.${username} = {
    imports = [
      ./home.nix
    ];
  };

  system.stateVersion = "22.05";

  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    wslConf.interop.appendWindowsPath = false;
    wslConf.network.generateHosts = false;
    defaultUser = username;
    startMenuLaunchers = true;

    # Enable integration with Docker Desktop (needs to be installed)
    docker-desktop.enable = false;
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune.enable = true;
  };

  services.locate = {
    enable = true;
    package = pkgs.mlocate;
    interval = "hourly";
    localuser = null;
  };

  systemd.services.code-server = {
    enable = true;
    description = "VS Code in the browser";
    serviceConfig = {
      ExecStart = "${code-server}/bin/code-server . --bind-addr=0.0.0.0:3000 --auth=none --user-data-dir /home/${username}/.config/Code --extensions-dir /home/${username}/.vscode/extensions";
      Restart = "always";
      User = username;
    };
    wantedBy = [ "multi-user.target" ];
  };

  systemd.services.init-chezmoi-public = {
    enable = true;
    description = "Init chezmoi-public";
    serviceConfig = {
      ExecStart = "${pkgs.chezmoi}/bin/chezmoi --exclude scripts --source /home/${username}/.config/chezmoi-public --cache /home/${username}/.cache/chezmoi-public --refresh-externals init --apply https://github.com/justmiles/dotfiles.git";
      Type = "oneshot";
      User = username;
    };
    wantedBy = [ "multi-user.target" ];
  };

  nix = {
    settings = {
      trusted-users = [ username ];
      accept-flake-config = true;
      auto-optimise-store = true;
    };

    registry = {
      nixpkgs = {
        flake = inputs.nixpkgs;
      };
    };

    nixPath = [
      "nixpkgs=${inputs.nixpkgs.outPath}"
      "nixos-config=/etc/nixos/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];

    package = pkgs.nixFlakes;
    extraOptions = ''experimental-features = nix-command flakes'';

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };
}
