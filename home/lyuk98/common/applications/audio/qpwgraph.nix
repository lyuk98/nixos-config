{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Create option to enable qpwgraph
  options.applications.audio.qpwgraph.enable = lib.mkEnableOption "qpwgraph";

  config = lib.mkIf config.applications.audio.qpwgraph.enable {
    # Add packages
    home.packages = [ pkgs.qpwgraph ];
  };
}
