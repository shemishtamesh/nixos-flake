{ pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "rebuild" ''
      flake_path="$HOME/.config/flake"
      git -C $flake_path add .
      git -C $flake_path add .
      git -C $flake_path commit -m 'update'
      sudo nixos-rebuild switch --flake $flake_path --show-trace \
          && home-manager switch --flake $flake_path --show-trace
      systemctl --user restart hyprpaper.service
      notify-send 'done rebuilding'
    '')

    (pkgs.writeShellScriptBin "notification-log" ''
      logfile=$1

      declare -a MSGBUF
      STATE=off
      MSGTIME=

      printbuf() {
        JOINED=$( echo "''${MSGBUF[@]}" | sed 's/,$//' )
        printf "%s\n%s\n\n" "--- ''${MSGTIME} ---" "''${JOINED}"
      }

      procmsg() {
        if [[ "''${1}" =~ member=Notify$ ]]; then
          STATE=on
          MSGTIME=$(date '+%Y-%m-%d %H:%M:%S')
          MSGBUF=()
        elif [[ "''${1}" =~ member=NotificationClosed$ ]]; then
          STATE=off
          printbuf
        else
          if [[ "''${STATE}" == "on" ]]; then
            if [[ "''${1}" =~ ^string ]]; then
              case "''${1}" in
                "string \"\"") ;;
                "string \"urgency\"") ;;
                "string \"sender-pid\"") ;;
                *)
                  MSGBUF+=$( echo -n "''${1}," )
                ;;
              esac
            fi
          fi
        fi
      }

      dbus-monitor "interface='org.freedesktop.Notifications'" | \
          while read -r line; do
            procmsg "$line" >> "$logfile"
          done
    '')

    (pkgs.writeShellScriptBin "bak" ''
      local filename="$1"
      if [[ "$filename" =~ .bak$ ]]; then
          mv "$filename" "''${filename%.bak}";
          exit 0;
      else
          mv "$filename" "$filename.bak";
          exit 0;
      fi
      echo "Error: $filename is not a valid file or directory.";
      exit 1;
    '')
  ];
}
