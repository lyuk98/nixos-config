{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Create option to enable DaVinci Resolve
  options.applications.video = {
    davinci-resolve = {
      enable = lib.mkEnableOption "DaVinci Resolve";
      studio.enable = lib.mkEnableOption "DaVinci Resolve Studio";
    };
  };

  config =
    let
      davinci-resolve = config.applications.video.davinci-resolve;
    in
    {
      # Add packages
      home.packages =
        (lib.optional davinci-resolve.enable pkgs.davinci-resolve)
        ++ (lib.optional davinci-resolve.studio.enable pkgs.davinci-resolve-studio);
    };
}
