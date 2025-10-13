{ inputs, ... }:
{
  # Import Home Manager module for Nix User Repository
  imports = [ inputs.nur.modules.homeManager.default ];
}
