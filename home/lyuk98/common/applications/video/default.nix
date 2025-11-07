{
  lib,
  config,
  ...
}:
{
  imports = [
    ./davinci-resolve.nix
    ./kdenlive.nix
    ./losslesscut.nix
    ./makemkv.nix
    ./mediainfo.nix
    ./obs-studio.nix
    ./subtitlecomposer.nix
    ./vlc.nix
  ];

  # Create option to enable all Video applications
  options.applications.video.enable = lib.mkEnableOption "all Video applications";

  # Enable all Video applications if enabled
  config.applications.video = lib.mkIf config.applications.video.enable {
    davinci-resolve.enable = lib.mkDefault (!config.applications.video.davinci-resolve.studio.enable);
    davinci-resolve.studio.enable = lib.mkDefault false;
    kdenlive.enable = lib.mkDefault true;
    losslesscut.enable = lib.mkDefault true;
    makemkv.enable = lib.mkDefault true;
    mediainfo.enable = lib.mkDefault true;
    obs-studio.enable = lib.mkDefault true;
    subtitlecomposer.enable = lib.mkDefault true;
    vlc.enable = lib.mkDefault true;
  };
}
