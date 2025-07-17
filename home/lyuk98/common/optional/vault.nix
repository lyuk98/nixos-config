{ pkgs, ... }:
{
  # Add binary version of Vault to user environment
  home.packages = [ pkgs.vault-bin ];
}
