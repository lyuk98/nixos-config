{
  # Add my custom packages
  customPackages = final: prev: import ../packages { pkgs = final; };
}
