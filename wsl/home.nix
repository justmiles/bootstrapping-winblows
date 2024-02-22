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
    # daemons
    openvscode-server

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
    terraform-docs
    packer
    rclone
    drone-cli
    nomad
    pre-commit
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

    # rust stuff
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

  extensions =
    (import (builtins.fetchGit {
      url = "https://github.com/nix-community/nix-vscode-extensions";
      ref = "refs/heads/master";
      rev = "0339519cb252f665ffc72cb524cd6dea7c9726c1";
    })).extensions.x86_64-linux;

  extensionsList = with extensions.vscode-marketplace; [
    # Golang
    golang.go
    # Terrafomr
    hashicorp.terraform
    hashicorp.hcl
    # Python
    ms-python.python
    # Java
    redhat.java
    vscjava.vscode-lombok
    # Generic language parsers / prettifiers
    esbenp.prettier-vscode
    redhat.vscode-yaml
    jkillian.custom-local-formatters
    # Generic tools
    eamodio.gitlens
    jebbs.plantuml
    # Install snazzy themes
    pkief.material-icon-theme
    # zhuangtongfa.Material-theme
    mtxr.sqltools
    mtxr.sqltools-driver-pg
    # Nix
    jnoortheen.nix-ide
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
      # (pkgs.callPackage ../modules/code-server.nix { })
      (pkgs.callPackage ../modules/go-markdown2confluence.nix { })
    ];
  };

  home.file = {
    Downloads.source = config.lib.file.mkOutOfStoreSymlink "/mnt/c/Users/${username}/Documents/workspaces";
    Downloads.target = "workspaces";
  };

  programs = {
    home-manager.enable = true;
    nix-index.enable = true;
    nix-index.enableZshIntegration = true;
    nix-index-database.comma.enable = true;

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
      package = pkgs.openvscode-server;
      extensions = extensionsList;
      enableUpdateCheck = true;
      enableExtensionUpdateCheck = true;
      keybindings = [
        {
          key = "ctrl+q";
          command = "editor.action.commentLine";
          when = "editorTextFocus && !editorReadonly";
        }
      ];
      userSettings = {
        "workbench.colorTheme" = "Default Dark+";
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";
        "nix.formatterPath" = "nixpkgs-fmt";
        "editor.formatOnSave" = true;
        "nix.serverSettings" = {
          "nil" = {
            "formatting" = {
              "command" = [ "nixpkgs-fmt" ];
            };
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
