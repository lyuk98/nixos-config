{ pkgs, lib, ... }:
# Edit is only available in Nixpkgs 25.11 and later
lib.mkIf (lib.versionAtLeast lib.trivial.release "25.11") {
  environment = {
    # Add Microsoft Edit
    systemPackages = [ pkgs.msedit ];

    # Set Edit as default editor
    variables = {
      EDITOR = "edit";
    };
  };
}
