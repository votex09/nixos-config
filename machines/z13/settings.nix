#=====================================================================#
# FLOW Z13 MACHINE SETTINGS
#=====================================================================#
#- Machine-wide settings for the ASUS ROG Flow Z13 (GZ302EA). Apps are
#- chosen per user in users/<name>/settings.nix; machines/_template/settings.nix
#- lists every setting this file can hold.
{
  #--------------------------------------------------------------------#
  #-- Users
  #--------------------------------------------------------------------#
  users = {
    kylerj = {};
  };

  mainUser = "kylerj";

  #--------------------------------------------------------------------#
  #-- System (NixOS modules)
  #--------------------------------------------------------------------#
  #--- DO NOT CHANGE (the NixOS 26.05 installer)
  stateVersion = "26.05";

  #--- Language & Keyboard
  timeZone = "America/Phoenix";
  locale = "en_US.UTF-8";
  keyboardLayout = "us";
  consoleKeyMap = "us";

  #--- Window Manager Selection
  # Options: "niri"
  windowManager = "niri";

  #--- Kernel Selection
  # Options: "zen" | "latest" | "xanmod" | "cachyos"
  # Not cachyos: its 7.0.x builds hang the ASUS WMI controls on this model
  kernel = "zen";

  #--- Mouse Cursor
  # Options: "bibata" | "catppuccin"
  cursor = "bibata";
  cursorSize = 24;

  #--- Graphics Drivers (Radeon 8060S, no discrete GPU)
  gpu.type = "amd";

  #--- Bluetooth
  bluetooth.enable = true;

  #--- Syncthing File Sync
  syncthing.enable = true;

  #--- Flatpak, with Flatseal (RetroDECK)
  flatpak.enable = true;
}
