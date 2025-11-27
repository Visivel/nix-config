{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.vitals
    gnomeExtensions.dash-to-dock
  ];

  programs.dconf.profiles.user.databases = [{
    settings = {
      "org/gnome/shell" = {
        enabled-extensions = [
          "clipboard-indicator@tudmotu.com"
          "Vitals@CoreCoding.com"
          "user-theme@gnome-shell-extensions.gcampax.github.com"
        ];
      };

      "org/gnome/mutter" = {
        experimental-features = [ "scale-monitor-framebuffer" ];
        dynamic-workspaces = true;
        edge-tiling = true;
        attach-modal-dialogs = false;
      };

      "org/gnome/desktop/wm/preferences" = {
        resize-with-right-button = true;
        focus-mode = "click";
        button-layout = "appmenu:minimize,maximize,close";
      };

      "org/gnome/shell/extensions/clipboard-indicator" = {
        history-size = lib.gvariant.mkInt32 50;
        cache-size = lib.gvariant.mkInt32 25;
        notify-on-cycle = false;
        paste-on-select = true;
      };
    };
  }];
}