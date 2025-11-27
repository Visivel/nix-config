{ osConfig, lib, pkgs, ... }:

lib.mkMerge [
  {
    programs.git = {
      enable = true;
      settings = {
        user.name = lib.mkDefault (builtins.readFile osConfig.age.secrets.git-name.path);
        user.email = lib.mkDefault (builtins.readFile osConfig.age.secrets.git-email.path);
        init.defaultBranch = "main";
        pull.rebase = true;
        push.autoSetupRemote = true;
        core.editor = "nano";
        merge.conflictstyle = "diff3";
        diff.colorMoved = "default";
        rerere.enabled = true;
        branch.autosetupmerge = "always";
        branch.autosetuprebase = "always";
        commit.gpgsign = false;
        tag.gpgsign = false;
        fetch.prune = true;
        push.default = "simple";
        status.showUntrackedFiles = "all";
      };
      ignores = [
        "*~" "*.swp" "*.swo" ".DS_Store" ".direnv"
        "result" "result-*" "node_modules" ".env" ".env.local" "*.log"
      ];
    };

    programs.delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        navigate = true;
        light = false;
        side-by-side = true;
        line-numbers = true;
      };
    };

    programs.gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
        prompt = "enabled";
        aliases = {
          co = "pr checkout";
          pv = "pr view";
        };
      };
    };

    programs.lazygit = {
      enable = true;
      settings = {
        gui.theme.lightTheme = false;
      };
    };
  }
]