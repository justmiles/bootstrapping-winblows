{
  username,
  hostname,
  pkgs,
  inputs,
  ...
}: {
  time.timeZone = "America/Chicago";

  networking.hostName = "${hostname}";

  systemd.tmpfiles.rules = [
    "d /home/${username}/.config 0755 ${username} users"
    "d /home/${username}/.config/lvim 0755 ${username} users"
  ];

  programs.zsh.enable = true;
  environment.pathsToLink = ["/share/zsh"];
  environment.shells = [pkgs.zsh];

  environment.enableAllTerminfo = true;

  security.sudo.wheelNeedsPassword = false;

  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "docker"
    ];
  };

  environment.systemPackages = [
    (import ./win32yank.nix {inherit pkgs;})
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

  # systemd.user = {
  #   services.locate = {
  #     enable = true;
  #     locate = pkgs.mlocate;
  #     interval = "hourly";
  #   };
  # };

  systemd.services.openvscode-server = {
    enable = true;
    description = "Open VSCode Server";
    serviceConfig = {
      ExecStart = "${pkgs.openvscode-server}/bin/openvscode-server --accept-server-license-terms --without-connection-token --port=3000";
      Restart="always";
      User = username;
    };
    wantedBy = [ "multi-user.target" ];
  };

  systemd.services.init-chezmoi-public = {
    enable = true;
    description = "Init chezmoi-public";
    serviceConfig = {
      ExecStart = "${pkgs.chezmoi}/bin/chezmoi --exclude scripts --source /home/${username}/.config/chezmoi-public --cache /home/${username}/.cache/chezmoi-public --refresh-externals init --apply https://github.com/justmiles/dotfiles.git";
      Type="oneshot";
      User = username;
    };
    wantedBy = [ "multi-user.target" ];
  };

  nix = {
    settings = {
      trusted-users = [username];
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
