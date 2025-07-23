{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf config.programs.gnome-shell.enable {
  dconf.settings = {
    # Set default theme to Adwaita
    "org/gnome/desktop/background" = {
      picture-uri = "file://${pkgs.gnome-backgrounds}/share/backgrounds/gnome/adwaita-l.jpg";
      picture-uri-dark = "file://${pkgs.gnome-backgrounds}/share/backgrounds/gnome/adwaita-d.jpg";
      picture-options = "zoom";
      color-shading-type = "solid";
      primary-color = "#3071AE";
      secondary-color = "#000000";
    };
  };
}
