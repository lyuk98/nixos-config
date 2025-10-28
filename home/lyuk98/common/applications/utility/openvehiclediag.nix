{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Create option to enable Open Vehicle Diagnostics
  options.applications.utility.openvehiclediag.enable = lib.mkEnableOption "Open Vehicle Diagnostics";

  config = lib.mkIf config.applications.utility.openvehiclediag.enable {
    # Add packages
    home.packages = with pkgs; [
      # Open Vehicle Diagnostics
      openvehiclediag

      # CBFParser
      cbf-parser
    ];
  };
}
