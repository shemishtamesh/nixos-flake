{ lib, pkgs, config, ... }:
let
  gaps = "2";
  rounding = "10";
  toggle-bar = pkgs.writeShellScriptBin "toggle-bar" ''
    killall .waybar-wrapped
    if [[ $? -eq 0 ]]; then
        hyprctl keyword general:gaps_in 0
        hyprctl keyword general:gaps_out 0
        hyprctl keyword decoration:rounding 0
        exit 0
    fi

    hyprctl keyword general:gaps_in ${gaps}
    hyprctl keyword general:gaps_out ${gaps}
    hyprctl keyword decoration:rounding ${rounding}
    waybar
  '';
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      monitor = "eDP-1,1920x1080@60,0x0,1";
      bind = [
        "$mod CTRL SHIFT, q, exit"

        "$mod SHIFT, w, killactive"

        "$mod, c, cyclenext"

        "$mod, f, fullscreen, 1"
        "$mod SHIFT, f, fullscreen, 0"
        "$mod CTRL, f, fakefullscreen"
        "$mod, t, togglefloating, 0"

        "$mod, r, togglesplit"

        "$mod CTRL, c, exec, hyprpicker --autocopy"
        "$mod, SPACE, exec, rofi -show drun"
        "$mod, RETURN, exec, kitty"
        "$mod, i, exec, firefox"
        "$mod SHIFT, i, exec, firefox --private-window"

        "$mod, b, exec, ${lib.getExe toggle-bar}"

        "CTRL, XF86Reload, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86Reload, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_SINK@ toggle"

        "$mod, Escape, exec, wlogout"

        "$mod, Tab, hyprexpo:expo, toggle"
        "$mod, XF86Reload, togglespecialworkspace, chat"
        "$mod SHIFT, XF86Reload, movetoworkspace, special:chat"
        "$mod, XF86AudioPlay, togglespecialworkspace, music"
        "$mod SHIFT, XF86AudioPlay, movetoworkspace, special:music"
        "$mod, 0, togglespecialworkspace, special"
        "$mod SHIFT, 0, movetoworkspace, special"
        "$mod, n, workspace, empty"
      ] ++ (
        builtins.concatLists (builtins.genList
          (
            i:
            let num = i + 1;
            in
            [
              "$mod, ${toString num}, workspace, ${toString num}"
              "$mod SHIFT, ${toString num}, movetoworkspace, ${toString num}"
            ]
          ) 9)
      ) ++ (
        builtins.concatLists (builtins.genList
          (
            i:
            let num = i + 1;
            in
            [
              "$mod CTRL, ${toString num}, exec, hyprctl keyword cursor:zoom_factor ${toString (num)}"
            ]
          ) 9)
      );
      bindr = [
        ", XF86Reload, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ];
      binde = [
        "$mod, mouse_up, workspace, e-1"
        "$mod, mouse_down, workspace, e+1"
        "$mod, bracketleft, workspace, e-1"
        "$mod, bracketright, workspace, e+1"

        "$mod, h, movefocus, l"
        "$mod, j, movefocus, d"
        "$mod, k, movefocus, u"
        "$mod, l, movefocus, r"
        "$mod SHIFT, h, swapwindow, l"
        "$mod SHIFT, j, swapwindow, d"
        "$mod SHIFT, k, swapwindow, u"
        "$mod SHIFT, l, swapwindow, r"
        "$mod CTRL, h, movewindow, l"
        "$mod CTRL, j, movewindow, d"
        "$mod CTRL, k, movewindow, u"
        "$mod CTRL, l, movewindow, r"
        "$mod ALT, h, resizeactive, -10 0"
        "$mod ALT, j, resizeactive, 0 10"
        "$mod ALT, k, resizeactive, 0 -10"
        "$mod ALT, l, resizeactive, 10 0"
        "$mod ALT SHIFT, h, resizeactive, -1 0"
        "$mod ALT SHIFT, j, resizeactive, 0 1"
        "$mod ALT SHIFT, k, resizeactive, 0 -1"
        "$mod ALT SHIFT, l, resizeactive, 1 0"
      ];
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      bindel = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-"
        "SHIFT, XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%+"
        "SHIFT, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-"
        "CTRL, XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 1%+"
        "CTRL, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 1%-"
        "CTRL SHIFT, XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 10%+"
        "CTRL SHIFT, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 10%-"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86MonBrightnessUp, exec, brightnessctl set +1%"
        ", XF86MonBrightnessDown, exec, brightnessctl set 1%-"
        "SHIFT, XF86MonBrightnessUp, exec, brightnessctl set +10%"
        "SHIFT, XF86MonBrightnessDown, exec, brightnessctl set 10%-"
      ];
      input = {
        kb_layout = "us,il";
        kb_options = "grp:alt_space_toggle";
      };
      general = {
        gaps_in = gaps;
        gaps_out = gaps;
        border_size = 1;

        allow_tearing = false;

        resize_on_border = true;

        "col.active_border" = "rgb(${config.colorScheme.palette.base07}) rgb(${config.colorScheme.palette.base0A}) 180deg";
      };
      decoration = {
        dim_special = 0.8;
        rounding = rounding;
      };
      dwindle.preserve_split = true;
      animations = {
        bezier = [
          "wind, 0.05, 0.9, 0.1, 1.05"
          "winIn, 0.1, 1.1, 0.1, 1.1"
          "winOut, 0.3, -0.3, 0, 1"
          "liner, 1, 1, 1, 1"
        ];
        animation = [
          "windows, 1, 6, wind, slide"
          "windowsIn, 1, 6, winIn, slide"
          "windowsOut, 1, 5, winOut, slide"
          "windowsMove, 1, 5, wind, slide"
          "border, 1, 1, liner"
          "borderangle, 1, 30, liner, loop"
          "fade, 1, 10, default"
          "workspaces, 1, 5, wind"
        ];
      };
      misc = {
        force_default_wallpaper = 1;
        disable_hyprland_logo = false;
      };
      windowrulev2 = [
        "workspace special:music silent, class:(spotify)"
        "workspace special:chat silent, class:(discord)"
      ];
      exec-once = [
        "hyprpaper"
        "waybar"
        "[workspace special:music silent] spotify"
        "[workspace special:music silent] Discord"
        "copyq --start-server"
        "playerctld"
      ];
    };
    plugins = [
      pkgs.hyprlandPlugins.hyprexpo
    ];
  };
}