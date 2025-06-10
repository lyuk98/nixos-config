{ inputs, pkgs, ... }:
let
  # Specify package used for Edit
  edit = inputs.nur-packages-dtomvan.packages."${pkgs.system}".microsoft-edit;
in
{
  home = {
    # Add Edit by Microsoft
    packages = [ edit ];

    # Set Edit as a default editor
    sessionVariables = {
      EDITOR = "edit";
    };
  };
}
