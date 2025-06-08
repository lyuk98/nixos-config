{
  lib,
  config,
  ...
}:
{
  imports = [
    ./gnucash.nix
    ./libreoffice.nix
  ];

  # Create option to enable all Office applications
  options.applications.office.enable = lib.mkEnableOption "all office type applications";

  # Enable all Office applications if enabled
  config.applications.office = lib.mkIf config.applications.office.enable {
    gnucash.enable = lib.mkDefault true;
    libreoffice.enable = lib.mkDefault true;
  };
}
