{ pkgs, lib, ... }:
{
  home = {
    # Add Microsoft Edit
    packages = [ pkgs.msedit ];

    # Set Edit as default editor
    sessionVariables = {
      EDITOR = lib.mkDefault "edit";
    };
  };
}
