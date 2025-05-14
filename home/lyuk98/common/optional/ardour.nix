{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Add Ardour
    ardour

    # Add plugins used with Ardour
    drumgizmo # DrumGizmo
    guitarix # Guitarix
    gxplugins-lv2 # Extra LV2 plugins to compliment Guitarix
  ];
}
