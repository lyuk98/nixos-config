{ pkgs, lib, ... }:
# Edit is only available in Nixpkgs 25.11 and later
lib.mkIf (lib.versionAtLeast lib.trivial.release "25.11") {
  home = {
    # Add Microsoft Edit
    packages = [ pkgs.msedit ];

    # Set Edit as default editor
    sessionVariables = {
      EDITOR = "edit";
    };
  };
}
