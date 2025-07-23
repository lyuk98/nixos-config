{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Create option to enable MakeMKV
  options.applications.video.makemkv.enable = lib.mkEnableOption "MakeMKV";

  config = lib.mkIf config.applications.video.makemkv.enable {
    # Add packages
    home.packages = [ pkgs.makemkv ];
  };
}
