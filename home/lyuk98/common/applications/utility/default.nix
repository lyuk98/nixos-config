{
  lib,
  config,
  ...
}:
{
  imports = [
    ./bottles.nix
    ./openvehiclediag.nix
  ];

  # Create option to enable all Utility applications
  options.applications.utility.enable = lib.mkEnableOption "all Utility applications";

  # Enable all Utility applications if enabled
  config.applications.utility = lib.mkIf config.applications.utility.enable {
    bottles.enable = lib.mkDefault true;
    openvehiclediag.enable = lib.mkDefault true;
  };
}
