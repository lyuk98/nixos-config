{
  lib,
  config,
  ...
}:
{
  imports = [
    ./eloquent.nix
    ./ente-desktop.nix
    ./gnucash.nix
    ./libreoffice.nix
    ./standardnotes.nix
  ];

  # Create option to enable all Office applications
  options.applications.office.enable = lib.mkEnableOption "all office type applications";

  # Enable all Office applications if enabled
  config.applications.office = lib.mkIf config.applications.office.enable {
    eloquent.enable = lib.mkDefault true;
    ente-desktop.enable = lib.mkDefault true;
    gnucash.enable = lib.mkDefault true;
    libreoffice.enable = lib.mkDefault true;
    standardnotes.enable = lib.mkDefault true;
  };
}
