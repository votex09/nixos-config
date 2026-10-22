#=====================================================================#
# KYLERJ'S NIRI KEYBINDS (KDE PLASMA LAYOUT)
#=====================================================================#
#- kylerj's KDE Plasma shortcuts, translated to niri. lib.mkForce replaces
#- the repo's bind on a key both use; the repo's other binds stay.
{
  lib,
  pkgs,
  ...
}: {
  programs.niri.settings.binds = let
    # The title is what the Mod+/ cheatsheet (DMS) shows for the bind
    bind = title: action:
      lib.mkForce {
        inherit action;
        hotkey-overlay.title = title;
      };
    hidden = action:
      lib.mkForce {
        inherit action;
        hotkey-overlay.hidden = true;
      };
    dms = action: ["dms" "ipc" "call"] ++ lib.splitString " " action;
    # Volume keys still work on the lock screen
    locked = cmd:
      lib.mkForce {
        action.spawn = cmd;
        allow-when-locked = true;
        hotkey-overlay.hidden = true;
      };

    #--- Click a window to kill its process (KDE's xkill)
    killClicked = pkgs.writeShellScript "niri-kill-clicked" ''
      pid=$(niri msg --json pick-window | ${pkgs.jq}/bin/jq -r '.pid // empty')
      [ -n "$pid" ] && kill -9 "$pid"
    '';

    #--- power-saver -> balanced -> performance -> power-saver
    cyclePowerProfile = pkgs.writeShellScript "cycle-power-profile" ''
      case $(powerprofilesctl get) in
        power-saver) next=balanced ;;
        balanced) next=performance ;;
        *) next=power-saver ;;
      esac
      powerprofilesctl set "$next"
    '';
  in {
    #--- Apps (everything else through the launcher)
    "Mod+T" = bind "Terminal" {spawn = ["kitty"];};
    "Ctrl+Alt+Delete" = bind "Task manager" {spawn = dms "processlist toggle";};
    "Mod+Space" = bind "App launcher" {spawn = dms "spotlight toggle";};

    #--- Windows
    "Mod+F" = bind "Fullscreen" {fullscreen-window = {};};
    "Mod+W" = bind "Float / tile window" {toggle-window-floating = {};};
    "Mod+BackSpace" = bind "Maximize column on / off" {maximize-column = {};};
    "Mod+Page_Up" = bind "Window transparency on / off" {toggle-window-rule-opacity = {};};
    "Mod+Page_Down" = hidden {toggle-window-rule-opacity = {};};
    "Mod+Equal" = hidden {set-column-width = "+10%";};
    "Alt+Shift+Q" = bind "Kill a window (click it)" {spawn = ["${killClicked}"];};

    #--- Move windows (KDE quick tiling)
    "Mod+Left" = bind "Move left" {move-column-left = {};};
    "Mod+Right" = bind "Move right" {move-column-right = {};};
    "Mod+Up" = bind "Move up / to workspace above" {move-window-up-or-to-workspace-up = {};};
    "Mod+Down" =
      bind "Move down / to workspace below" {move-window-down-or-to-workspace-down = {};};
    "Mod+Shift+Left" = bind "Window to monitor left" {move-column-to-monitor-left = {};};
    "Mod+Shift+Right" = bind "Window to monitor right" {move-column-to-monitor-right = {};};

    #--- Focus
    "Mod+Alt+Left" = bind "Focus left" {focus-column-left = {};};
    "Mod+Alt+Right" = bind "Focus right" {focus-column-right = {};};
    "Mod+Alt+Up" = bind "Focus up / workspace above" {focus-window-or-workspace-up = {};};
    "Mod+Alt+Down" =
      bind "Focus down / workspace below" {focus-window-or-workspace-down = {};};

    #--- Workspaces (KDE desktops)
    "Mod+F1" = bind "Go to workspace 1-4" {focus-workspace = 1;};
    "Mod+F2" = hidden {focus-workspace = 2;};
    "Mod+F3" = hidden {focus-workspace = 3;};
    "Mod+F4" = hidden {focus-workspace = 4;};
    "Mod+Ctrl+Up" = bind "Workspace above" {focus-workspace-up = {};};
    "Mod+Ctrl+Down" = bind "Workspace below" {focus-workspace-down = {};};
    "Mod+Ctrl+Left" = bind "Focus monitor left" {focus-monitor-left = {};};
    "Mod+Ctrl+Right" = bind "Focus monitor right" {focus-monitor-right = {};};
    "Mod+Ctrl+Shift+Up" = bind "Window to workspace above" {move-column-to-workspace-up = {};};
    "Mod+Ctrl+Shift+Down" =
      bind "Window to workspace below" {move-column-to-workspace-down = {};};
    "Mod+Ctrl+Shift+Left" = hidden {move-column-to-monitor-left = {};};
    "Mod+Ctrl+Shift+Right" = hidden {move-column-to-monitor-right = {};};

    #--- Overview (KDE grid and present windows)
    "Mod+G" = bind "Overview" {toggle-overview = {};};
    "Mod+F7" = hidden {toggle-overview = {};};

    #--- Screenshots & recording (KDE Spectacle keys)
    "Mod+Shift+S" = bind "Screenshot region" {spawn = dms "quickCapture screenshot region edit";};
    "Mod+Shift+A" = bind "Screenshot window" {spawn = dms "quickCapture screenshot window edit";};
    "Mod+Shift+D" = bind "Screenshot screen" {spawn = dms "quickCapture screenshot full edit";};
    "Mod+Shift+R" = bind "Start / stop recording" {spawn = dms "quickCapture recordToggle portal";};

    #--- Session & system
    "Mod+Shift+Escape" = bind "Shortcuts to app on / off" {toggle-keyboard-shortcuts-inhibit = {};};
    "Ctrl+Alt+BackSpace" = bind "Restart shell" {spawn = ["dms" "restart"];};
    "Mod+B" = bind "Next power profile" {spawn = ["${cyclePowerProfile}"];};

    #--- Volume in 1% steps, mic mute
    "Shift+XF86AudioRaiseVolume" = locked (dms "audio increment 1");
    "Shift+XF86AudioLowerVolume" = locked (dms "audio decrement 1");
    "Mod+XF86AudioMute" = locked (dms "audio micmute");
  };
}
