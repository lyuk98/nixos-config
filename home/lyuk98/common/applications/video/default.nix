{
  lib,
  config,
  ...
}:
{
  imports = [
    ./kdenlive.nix
    ./makemkv.nix
    ./subtitlecomposer.nix
    ./vlc.nix
  ];

  # Create option to enable all Video applications
  options.applications.video.enable = lib.mkEnableOption "all Video applications";

  # Enable all Video applications if enabled
  config.applications.video = lib.mkIf config.applications.video.enable {
    kdenlive.enable = lib.mkDefault true;
    makemkv.enable = lib.mkDefault true;
    subtitlecomposer.enable = lib.mkDefault true;
    vlc.enable = lib.mkDefault true;
  };
}
