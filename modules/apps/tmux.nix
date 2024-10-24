{ pkgs, ... }:
{
  programs.tmux.enable = true;
  programs.tmux = {
    clock24 = true;
    escapeTime = 0;
    keyMode = "vi";
    newSession = true;
    shortcut = "Space";
    # shortcut = "a";
    historyLimit = 5000;
    # plugins = [
    #   pkgs.tmuxPlugins.better-mouse-mode
    #   pkgs.tmuxPlugins.vim-tmux-navigator
    #   pkgs.tmuxPlugins.resurrect
    #   pkgs.tmuxPlugins.continuum
    # ];
    /*
      extraConfig = # tmux
      ''
        set -g mouse on
      '';
    */
  };
}
