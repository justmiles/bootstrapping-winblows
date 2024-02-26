{ config
, pkgs
, username
, nix-index-database
, nix-vscode-extensions
, ...
}:
let
  unstable-packages = with pkgs.unstable; [
    bat
    bottom
    coreutils
    curl
    du-dust
    fd
    findutils
    fx
    git
    git-crypt
    htop
    killall
    lunarvim
    mosh
    mlocate
    neovim
    procs
    ripgrep
    sd
    tmux
    tree
    unzip
    vim
    wget
    zip
  ];

  stable-packages = with  pkgs; [

    # key tools
    gh
    just
    awscli2
    ssm-session-manager-plugin
    taskwarrior
    gopass
    csvq
    restic
    pipx
    pwgen
    chezmoi
    packer
    rclone
    drone-cli
    nomad
    pre-commit
    nomad
    terraform-docs
    terraform
    tfswitch
    gnumake
    wslu

    # core languages
    rustup
    go
    lua
    nodejs
    python3
    typescript

    # rust
    cargo-cache
    cargo-expand

    # local dev stuf
    mkcert
    httpie
    ran
    rsync
    unzip
    jq
    yq
    grex
    gron
    watchexec

    # language servers
    ccls # c / c++
    gopls
    gdlv
    nodePackages.typescript-language-server
    pkgs.nodePackages.vscode-langservers-extracted # html, css, json, eslint
    nodePackages.yaml-language-server
    sumneko-lua-language-server
    nil # nix
    nodePackages.pyright

    # formatters and linters
    alejandra # nix
    black # python
    ruff # python
    nixpkgs-fmt # nix
    golangci-lint
    lua52Packages.luacheck
    nodePackages.prettier
    shellcheck
    shfmt
    statix # nix
    sqlfluff
    tflint
    hclfmt
  ];

  extensionsList = with nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace; [
    # Golang
    golang.go

    # Terrafom
    hashicorp.terraform
    hashicorp.hcl

    # Python
    ms-python.python

    # Java
    redhat.java
    vscjava.vscode-lombok

    # Nix
    jnoortheen.nix-ide

    # Generic language parsers / prettifiers
    esbenp.prettier-vscode
    redhat.vscode-yaml
    jkillian.custom-local-formatters

    # Generic tools
    eamodio.gitlens
    jebbs.plantuml

    # DB stuff
    mtxr.sqltools
    mtxr.sqltools-driver-pg

    # Eye candy
    pkief.material-icon-theme
    zhuangtongfa.material-theme

    # Misc
    jkillian.custom-local-formatters
  ];

in
{
  imports = [
    nix-index-database.hmModules.nix-index
  ];

  home = {
    username = "${ username}";
    homeDirectory = "/home/${ username}";
    stateVersion = "22.11";
    sessionVariables. EDITOR = "vim";
    sessionVariables. SHELL = "/etc/profiles/per-user/${username}/bin/zsh";
    packages = stable-packages ++ unstable-packages ++ extensionsList ++ [
      (pkgs.callPackage ../modules/codegpt.nix { })
      (pkgs.callPackage ../modules/go-markdown2confluence.nix { })
    ];
  };

  home.file = {
    workspaces.source = config.lib.file.mkOutOfStoreSymlink "/mnt/c/Users/${username}/Documents/workspaces";
    workspaces.target = "workspaces";
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 3600;
    maxCacheTtl = 3600;
    pinentryFlavor = "tty";
    enableScDaemon = false;
  };

  programs = {
    home-manager.enable = true;
    nix-index.enable = true;
    nix-index.enableZshIntegration = true;
    nix-index-database.comma.enable = true;

    gpg.enable = true;

    fzf.enable = true;
    fzf.enableZshIntegration = true;
    lsd.enable = true;
    lsd.enableAliases = true;
    zoxide.enable = true;
    zoxide.enableZshIntegration = true;
    broot.enable = true;
    broot.enableZshIntegration = true;

    vscode = {
      enable = true;
      extensions = extensionsList;
      enableUpdateCheck = true;
      enableExtensionUpdateCheck = true;

      keybindings = [
        {
          key = "ctrl+q";
          command = "editor.action.commentLine";
          when = "editorTextFocus && !editorReadonly";
        }
        {
          key = "ctrl+d";
          command = "editor.action.copyLinesDownAction";
          when = "editorTextFocus && !editorReadonly";
        }
      ];

      userSettings = {
        "workbench.colorTheme" = "Visual Studio Dark";
        "workbench.iconTheme" = "material-icon-theme";
        "workbench.startupEditor" = "newUntitledFile";
        "editor.renderWhitespace" = "all";
        "editor.formatOnSave" = true;
        "editor.tabSize" = 2;
        "extensions.ignoreRecommendations" = true;
        "extensions.autoCheckUpdates" = false;
        "explorer.confirmDelete" = false;
        "extensions.autoUpdate" = false;
        "files.watcherExclude" = {
          "**/vendor/**" = true;
          "**/.config/**" = true;
        };
        "gitlens.mode.statusBar.enabled" = false;
        "gitlens.hovers.currentLine.over" = "line";
        "explorer.confirmDragAndDrop" = false;
        "redhat.telemetry.enabled" = false;
        "telemetry.telemetryLevel" = "off";
        "files.associations" = {
          "*.hcl" = "hcl";
          "*.nomad.hcl" = "hcl";
          "*.pkr.hcl" = "hcl";
        };
        "customLocalFormatters.formatters" = [
          {
            "command" = "${pkgs.terraform}/bin/terraform fmt -";
            "languages" = [
              "terraform"
            ];
          }
          {
            "command" = "${pkgs.nomad}/bin/nomad fmt -";
            "languages" = [
              "nomad"
            ];
          }
          {
            "command" = "${pkgs.hclfmt}/bin/hclfmt";
            "languages" = [
              "hcl"
            ];
          }
        ];
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";
        "nix.formatterPath" = "nixpkgs-fmt";
        "nix.serverSettings" = {
          "nil" = {
            "formatting" = { "command" = [ "nixpkgs-fmt" ]; };
          };
        };
      };
    };

    direnv.enable = true;
    direnv.enableZshIntegration = true;
    direnv.nix-direnv.enable = true;

    zsh = {
      enable = true;
      autocd = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      defaultKeymap = "emacs";
      history.size = 10000;
      history.save = 10000;
      history.expireDuplicatesFirst = true;
      history.ignoreDups = true;
      history.ignoreSpace = true;
      historySubstringSearch.enable = true;

      shellAliases = {
        gc = "nix-collect-garbage --delete-old";
        show_path = "echo $PATH | tr ':' '\n'";

        pbcopy = "/mnt/c/Windows/System32/clip.exe";
        pbpaste = "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -command 'Get-Clipboard'";
        explorer = "/mnt/c/Windows/explorer.exe";
      };

      envExtra = ''
        export PATH=$PATH:$HOME/.local/bin
      '';

      initExtra = ''
        # fixes duplication of commands when using tab-completion
        export LANG=C.UTF-8

        autoload -U +X compinit && compinit
        autoload -U +X bashcompinit && bashcompinit

        for f in $(find ~/.bashrc.d -type f | sort -r ); do
            source $f || echo "[$f] could not load - exit code $?"
        done
      '';
    };
  };
}
